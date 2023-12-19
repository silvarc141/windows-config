$dotfilesRepo = 'https://github.com/silvarc141/dotfiles.git'
$packagesList = "$PSScriptRoot\packages-list.json"
$componentsDir = "$PSScriptRoot\user-components"

#todo iterate through all user components

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

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
chezmoi apply --force --keep-going

$packagesListObject = Get-Content -Raw -Path $packagesList | ConvertFrom-Json

foreach ($category in $packagesListObject) {
    foreach ($package in $category.packages) {
        if ($package.manager -eq 'scoop') {
            scoop install $package.value
        }
    }
}

Write-Host "Reapplying dotfiles after installation" -ForegroundColor "Yellow"
chezmoi apply --force --keep-going