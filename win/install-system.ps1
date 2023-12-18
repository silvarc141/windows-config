$packagesList = "$PSScriptRoot\packages-list.json"
$componentsDir = "$PSScriptRoot\system-components"

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

#todo review components, iterate through all system components
. $componentsDir/setup-windows.ps1
. $componentsDir/schedule-tasks.ps1

# Update winget
$results = (winget --version) | Select-String -Pattern 'v(\d)\.(\d).*'
$major = $results.Matches.Groups[1].Captures.Value -le 1
$minor = $results.Matches.Groups[2].Captures.Value -lt 6

if($major -and $minor) {
    $API_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $DOWNLOAD_URL = $(Invoke-RestMethod $API_URL).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
    Invoke-WebRequest -URI $DOWNLOAD_URL -OutFile winget.msixbundle -UseBasicParsing
    Add-AppxPackage winget.msixbundle
    Remove-Item winget.msixbundle
}
else {
    winget upgrade winget
}

$packagesListObject = Get-Content -Raw -Path $packagesList | ConvertFrom-Json

#todo support custom commands/parameters in json
foreach ($category in $packagesListObject) {
    foreach ($package in $category.packages) {
        if ($package.manager -eq 'winget') {
            winget install $package.value --silent --accept-package-agreements --source winget
        }
    }
}

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');