Write-Host "Installing system-wide components..." -ForegroundColor "Yellow"
Start-Process -FilePath $PSScriptRoot\install-system.ps1 -Wait

Write-Host "Installing user-specific components..." -ForegroundColor "Yellow"
Start-Process -FilePath $PSScriptRoot\install-user.ps1 -Wait