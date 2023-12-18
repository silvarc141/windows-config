Write-Host "Installing system-wide components..." -ForegroundColor "Yellow"
& $env:PSScriptRoot/install-system.ps1

Write-Host "Installing user-specific components..." -ForegroundColor "Yellow"
& $env:PSScriptRoot/install-user.ps1