$dotfilesRepo = 'https://github.com/silvarc141/dotfiles.git'
$packagesList = "$PSScriptRoot\packages-list.json"

Write-Host "Setting up Scoop..." -ForegroundColor "Yellow"

$HoldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
$ErrorActionPreference = $HoldErrorActionPreference

if(![Boolean](Get-Command scoop -ErrorAction SilentlyContinue)) {
    "$(Invoke-RestMethod get.scoop.sh)" | Invoke-Expression
}

scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add sysinternals
scoop bucket add DEV-tools https://github.com/anderlli0053/DEV-tools.git
scoop update

Write-Host "Installing installation dependencies..." -ForegroundColor "Yellow"
scoop install main/aria2
scoop install main/git
scoop install main/chezmoi

Write-Host "Installing dotfiles..." -ForegroundColor "Yellow"
chezmoi init $dotfilesRepo --force --keep-going
chezmoi update --force --keep-going

Write-Host "Installing packages..." -ForegroundColor "Yellow"
$packagesListObject = Get-Content -Raw -Path $packagesList | ConvertFrom-Json

foreach ($category in $packagesListObject) {
    foreach ($package in $category.packages) {
        if ($package.manager -eq 'scoop') {
            Write-Host "`nInstalling $($package.value)"
            scoop install $package.value
            scoop update $package.value
        }
    }
}

Write-Host "Reapplying dotfiles after installation..." -ForegroundColor "Yellow"
chezmoi update --force --keep-going

Write-Host "Removing user startup apps..." -ForegroundColor "Yellow"
("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", 
"HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce") |
ForEach-Object { @{Path = $_; Item = Get-Item -Path $_} } |
Where-Object { $_.Item.ValueCount -ne 0 } |
ForEach-Object { Remove-ItemProperty -Path $_.Path -Name $_.Item.Property }

Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\*" -Force