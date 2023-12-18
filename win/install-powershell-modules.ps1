Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"

Install-Module Posh-Git -Scope CurrentUser -Force
Install-Module PSWindowsUpdate -Scope CurrentUser -Force

Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force
Refresh-Environment