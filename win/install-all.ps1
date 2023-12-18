Write-Host "Installing system-wide components..." -ForegroundColor "Yellow"
& $PSScriptRoot\install-system.ps1 | Out-Null

Write-Host "Installing user-specific components..." -ForegroundColor "Yellow"
& $PSScriptRoot\install-user.ps1 | Out-Null