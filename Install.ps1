# ==================================================
# dynatrace installation script
# ==================================================
# configuration section
# ==================================================

$ProgressPreference = "SilentlyContinue"

$cfgTenant = $env:ENVIRONMENTID
$cfgApiToken = $env:TOKEN
$cfgConnectionPoint = $env:CONNECTIONPOINT

$NEWLINE = "`r`n"
$agentDownloadTargetPath = "$env:StartupLocalStorage\oneagent-installer-latest"
$logPath = "log.txt"

if (($env:DT_SSL_MODE -eq "all")) {
	$cfgSslMode = $env:DT_SSL_MODE
}

# ==================================================
# function section
# ==================================================

function Log($level, $content) {
	$line = "{0} {1} {2}" -f (Get-Date), $level, $content
	
	try {
	    Write-Host ("LOG: {0}" -f $line)
	} catch {
	}
	
	try {
	    Write-Output $line | Out-File -Encoding ascii -Append $logPath
	} catch {
	}
}

function LogInfo($content) {
	Log "INFO" $content
}

function LogWarning($content) {
	Log "WARNING" $content
}

function LogError($content) {
	if ($_.Exception -ne $null) {
		Log "ERROR" ("Exception.Message = {0}" -f $_.Exception.Message)
	}
	Log "ERROR" $content
}

function SetupSslAcceptAll {
	$codeProvider = New-Object Microsoft.CSharp.CSharpCodeProvider	
	$codeCompilerParams = New-Object System.CodeDom.Compiler.CompilerParameters
	$codeCompilerParams.GenerateExecutable = $false
	$codeCompilerParams.GenerateInMemory = $true
	$codeCompilerParams.IncludeDebugInformation = $false
	$codeCompilerParams.ReferencedAssemblies.Add("System.DLL") > $null
	$trustAllSource=@'
		namespace Local.ToolkitExtensions.Net.CertificatePolicy {
			public class TrustAll : System.Net.ICertificatePolicy {
				public TrustAll() {}
				public bool CheckValidationResult(System.Net.ServicePoint sp,System.Security.Cryptography.X509Certificates.X509Certificate cert, System.Net.WebRequest req, int problem) {
					return true;
				}
			}
		}
'@ 
	
	$trustAllResults = $codeProvider.CompileAssemblyFromSource($codeCompilerParams, $trustAllSource)
	$truxtAllAssembly=$trustAllResults.CompiledAssembly
        
	$trustAll = $truxtAllAssembly.CreateInstance("Local.ToolkitExtensions.Net.CertificatePolicy.TrustAll")
        
	[System.Net.ServicePointManager]::CertificatePolicy = $trustAll
	
	$allProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
	[System.Net.ServicePointManager]::SecurityProtocol = $allProtocols	
}

function ExitFailed() {
	Log "ABORT" "Installation failed. See log.txt for more information."
	Exit 1
}

function ExitSuccess() {
	Exit 0
}

# ==================================================
# main section
# ==================================================

LogInfo "-------------------------------------------"
LogInfo "Installing Dynatrace OneAgent"
LogInfo "-------------------------------------------"

if ($cfgTenant -eq $null) {
	LogError "Please make sure that the environment variable ENVIRONMENTID is set."
	ExitFailed
}

if ($cfgApiToken -eq $null) {
	LogError "Please make sure that the environment variable TOKEN is set."
	ExitFailed
}

if ($cfgConnectionPoint -eq $null)  {
	$cfgConnectionPoint = "http://{0}.live.dynatrace.com" -f $cfgTenant
}

if ($cfgApiToken.length -eq 16) { # it is a tenant token
    $agentDownloadQuery = "{0}/installer/agent/windows/exe/latest/{1}" -f $cfgConnectionPoint, $cfgApiToken
    $agentComesConfigured = $true
    $agentDownloadTargetPath = "$agentDownloadTargetPath.exe"
} elseif ($cfgApiToken.length -eq 21) { # it is an API token
    $agentDownloadQuery = "{0}/api/v1/deployment/installer/agent/windows/default-unattended/latest?Api-Token={1}" -f $cfgConnectionPoint, $cfgApiToken
    $agentComesConfigured = $false
    $agentDownloadTargetPath = "$agentDownloadTargetPath.msi"
} else {
    LogError "Invalid Token: {0}. Aborting installation of OneAgent, your Azure Cloud Service will work unaffected however." -f $cfgApiToken
    ExitFailed
}

LogInfo ("TENANT:           {0}" -f $cfgTenant)
LogInfo ("CONNECTION POINT: {0}" -f $cfgConnectionPoint)
LogInfo ("TOKEN:            {0}" -f $cfgApiToken)

# download
try {
	LogInfo "download source: $agentDownloadQuery"
	LogInfo "download target: $agentDownloadTargetPath"
	
	if ($cfgSslMode -eq "all") {
		LogInfo "accepting all ssl certificates"
		SetupSslAcceptAll
	}

	LogInfo "downloading..."
	Invoke-WebRequest $agentDownloadQuery -OutFile $agentDownloadTargetPath
} catch {
	LogError "Failed to download OneAgent."
	ExitFailed
}

if ($agentComesConfigured) {
    $cfgTenantToken = $cfgApiToken
    $agentConnectionPoint = $cfgConnectionPoint
} else {
    # read connectioninfo
    try {
	    LogInfo "Reading Manifest"
        
        $manifestDownloadQuery = "{0}/api/v1/deployment/installer/agent/connectioninfo?Api-Token={1}" -f $cfgConnectionPoint, $cfgApiToken
        $manifestFilePath = $env:StartupLocalStorage + "\manifest.json"

        Invoke-WebRequest $manifestDownloadQuery -OutFile $manifestFilePath

	    $manifest =  (Get-Content $manifestFilePath -Raw) | ConvertFrom-Json
	
	    $cfgTenantToken = $manifest.tenantToken
	    $agentConnectionPoint = ""
	
	    LogInfo "tenant token: $cfgTenantToken"
	
	    if ($manifest.communicationEndpoints -ne $null) {
		    foreach ($cp in $manifest.communicationEndpoints) {
			    LogInfo "connection point: $cp"
			    if ($agentConnectionPoint -ne "") {
				    $agentConnectionPoint = $agentConnectionPoint + ";"
			    }
			    $agentConnectionPoint = $agentConnectionPoint + $cp
		    }	
	    } elseif ($env:DT_CONNECTION_POINT -ne $null){
		    $agentConnectionPoint = $env:DT_CONNECTION_POINT
	    }
	
	    if ($cfgTenantToken -eq $null) {
		    throw "invalid tenant token"
	    }
	
	    if ($agentConnectionPoint -eq "") {
		    throw "invalid connection point"
	    }
	
    } catch {
	    LogError "Failed to read manifest"
	    ExitFailed
    }
}

$argList = "SERVER=$agentConnectionPoint TENANT=$cfgTenant PROCESSHOOKING=1 TENANT_TOKEN=$cfgTenantToken APP_LOG_CONTENT_ACCESS=1"

try {
    $process = Start-Process -FilePath "$agentDownloadTargetPath" -ArgumentList "/quiet $argList" -Wait -PassThru
    $process.WaitForExit()
} catch {
    LogError "Failed to run OneAgent installer"
    ExitFailed
}

ExitSuccess
