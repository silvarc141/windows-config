Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
"$(Invoke-RestMethod get.scoop.sh)" | Invoke-Expression
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add sysinternals
# scoop bucket add DEV-tools https://github.com/anderlli0053/DEV-tools.git

Write-Host "Installing installation dependencies..." -ForegroundColor "Yellow"
scoop install main/aria2
scoop install main/git
scoop install main/chezmoi

Write-Host "Installing dotfiles..." -ForegroundColor "Yellow"
chezmoi init --apply https://github.com/silvarc141/dotfiles.git