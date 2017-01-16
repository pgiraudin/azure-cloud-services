$args >> output.txt

$tenant = $args[0]
$token = $args[1]
$url = "https://$tenant.live.dynatrace.com/api/v1/deployment/installer/agent/windows/default/latest"

$storagedir = "$env:StartupLocalStorage"
$file = "$storagedir\oneagent-installer-latest.exe"

$webclient = New-Object System.Net.WebClient
$webclient.Headers.Add("Authorization","Api-Token $token");
$webclient.DownloadFile($url,$file)

exit 0
