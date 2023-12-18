Write-Host "Installing system-wide components..." -ForegroundColor "Yellow"
Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList "$PSScriptRoot\install-system.ps1"

Write-Host "Installing user-specific components..." -ForegroundColor "Yellow"
Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList "$PSScriptRoot\install-user.ps1"