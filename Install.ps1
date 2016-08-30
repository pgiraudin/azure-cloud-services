$args >> output.txt

$tenant = $args[0]
$token = $args[1]
$url = "https://$tenant.live.dynatrace.com/installer/agent/windows/exe/latest/$token"

$storagedir = "$env:StartupLocalStorage"
$file = "$storagedir\oneagent-installer-latest.exe"

$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($url,$file)

exit 0
