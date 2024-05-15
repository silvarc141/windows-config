param(
    [string]$Config = 'default',
    [bool]$InstallSystem = $True,
    [bool]$InstallUser = $True,
    [bool]$Reboot = $False,
    [bool]$RestartExplorer = $True
)

$configPathBase = "$PSScriptRoot\configs"
$configPathDefault = "$configPathBase\default.json"

$configPath = "$configPathBase\$Config.json"
if(!(Test-Path $configPath)) { $configPath = $configPathDefault }

$configObject = Get-Content -Raw -Path $configPath | ConvertFrom-Json
if($configObject -eq $null) { $configObject = Get-Content -Raw -Path $configPathDefault}

if($InstallSystem)
{
    Write-Host "Starting system configuration..." -ForegroundColor "Yellow"
    Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList .\system-install.ps1
}

if($InstallUser)
{
    Write-Host "Starting user configuration..." -ForegroundColor "Yellow"
    Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList .\user-install.ps1
}

Write-Host "Finalizing..." -ForegroundColor "Yellow"

# Stop explorer to immediately apply some changes. Windows will restart it on its own.
if($RestartExplorer) { Stop-Process -ProcessName explorer -Force }

if($Reboot) { shutdown /r /t 0 }
