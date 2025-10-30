param($ConfigPath)

function Pass-Parameters {
    Param ([hashtable]$NamedParameters)
    return ($NamedParameters.GetEnumerator()|%{"-$($_.Key) `"$($_.Value)`""}) -join " "
}

# Self-elevate the script if required while passing parameters
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + (Pass-Parameters $MyInvocation.BoundParameters) + " " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine -Wait
        Exit
    }
}

$configObject = Get-Content -Raw -Path $ConfigPath | ConvertFrom-Json

Write-Host "Updating winget..." -ForegroundColor "Yellow"

winget upgrade winget --silent --accept-package-agreements --accept-source-agreements

Write-Host "Processing system configuration modules..." -ForegroundColor "Yellow"

# Relative to PSScriptRoot because runas changes the path
$modulesPath = "$PSScriptRoot\..\modules\system\"

Get-ChildItem $modulesPath | ForEach-Object {
    Write-Host "Configuring system $([System.IO.Path]::GetFileNameWithoutExtension($_))" -ForegroundColor "Yellow"
    . $_.FullName
}

Write-Host "Installing system packages..." -ForegroundColor "Yellow"
foreach ($package in $configObject.packages) {
    if ($package.manager -eq 'winget') {
        Write-Host "`nInstalling package: $($package.id)"
        winget install --exact $package.id --silent --accept-package-agreements --source winget
    }
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
