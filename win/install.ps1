Write-Host "Starting system configuration..." -ForegroundColor "Yellow"
Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList .\system-install.ps1

Write-Host "Starting user configuration..." -ForegroundColor "Yellow"
Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList .\user-install.ps1

Write-Host "Finalizing..." -ForegroundColor "Yellow"
# Stop explorer to immediately apply some changes. Windows will restart it on its own.
Stop-Process -ProcessName explorer -Force
