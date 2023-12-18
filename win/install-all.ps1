Write-Host "Installing system-wide components..." -ForegroundColor "Yellow"
& $PSScriptRoot\install-system.ps1

Write-Host "Installing user-specific components..." -ForegroundColor "Yellow"
& $PSScriptRoot\install-user.ps1