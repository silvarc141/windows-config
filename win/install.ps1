Write-Host "Installing system components..." -ForegroundColor "Yellow"
Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList "$PSScriptRoot\system-install.ps1"

Write-Host "Installing user components..." -ForegroundColor "Yellow"
Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList "$PSScriptRoot\user-install.ps1"

Write-Host "Finalizing..." -ForegroundColor "Yellow"
# Stop explorer to immediately apply some changes. Windows will restart it on its own.
Stop-Process -ProcessName explorer -Force
