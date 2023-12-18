Push-Location $env:LOCALAPPDATA\Temp

#todo download installation files

Write-Host "Installing system-wide components..." -ForegroundColor "Yellow"
start-process powershell -verb runas -argumentlist "-file .\install-system.ps1"

Write-Host "Installing user-specific components..." -ForegroundColor "Yellow"
& .\install-user.ps1

#todo delete installation files

Pop-Location