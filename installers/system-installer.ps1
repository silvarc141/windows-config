param($ConfigObject)

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {

        $argument = @(
            "-File $($MyInvocation.MyCommand.Path)"
            "-$($PSBoundParameters.Keys)"
        )

        $args = @{
            FilePath = 'powershell.exe'
            Verb = 'RunAs'
            Wait = $True
            ArgumentList = $argument
        }

        Start-Process @args
        Exit
    }
}

Write-Host "Updating winget..." -ForegroundColor "Yellow"
$results = (winget --version) | Select-String -Pattern 'v(\d)\.(\d).*'
$major = $results.Matches.Groups[1].Captures.Value -le 1
$minor = $results.Matches.Groups[2].Captures.Value -lt 6

if ($major -and $minor) {
    $API_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $DOWNLOAD_URL = $(Invoke-RestMethod $API_URL).assets.browser_download_url | Where-Object { $_.EndsWith(".msixbundle") }
    Invoke-WebRequest -URI $DOWNLOAD_URL -OutFile winget.msixbundle -UseBasicParsing
    Add-AppxPackage winget.msixbundle
    Remove-Item winget.msixbundle
}
else {
    winget upgrade winget --silent --accept-package-agreements --accept-source-agreements
}

Write-Host "Processing system configuration modules..." -ForegroundColor "Yellow"

# Relative to PSScriptRoot because runas changes the path
$modulesPath = "$PSScriptRoot\..\modules\system\"

Get-ChildItem $modulesPath | ForEach-Object {
    Write-Host "Configuring system $([System.IO.Path]::GetFileNameWithoutExtension($_))" -ForegroundColor "Yellow"
    . $_.FullName
}

Write-Host "Installing system packages..." -ForegroundColor "Yellow"
foreach ($package in $ConfigObject.packages) {
    if ($package.manager -eq 'winget') {
        Write-Host "`nInstalling package: $($package.id)"
        winget install --exact $package.id --silent --accept-package-agreements --source winget
    }
    else {Write-Host $package.manager}
}

Write-Host "Removing system startup apps..." -ForegroundColor "Yellow"
$32bit = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$32bitRunOnce = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
$64bit = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
$64bitRunOnce = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce"

$32bit, $32bitRunOnce, $64bit, $64bitRunOnce |
ForEach-Object { @{Path = $_; Item = Get-Item -Path $_ } } |
Where-Object { $_.Item.ValueCount -ne 0 } |
ForEach-Object { Remove-ItemProperty -Path $_.Path -Name $_.Item.Property }

Start-Sleep -Seconds 50
