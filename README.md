# Windows dotfiles
## Requirements
- activated Windows license (for successful themeing)
- updated system (for no regressions)
- fresh system (for maximum reproducibility)
## Installation
### One-line
```
Set-ExecutionPolicy Bypass -Scope Process; (new-object net.webclient).DownloadString('https://raw.github.com/silvarc141/windows-config/main/install.ps1') | iex
```
### Clone
1. Clone repo
2. cd inside
3. Run `.\install.ps1 -Local 1`
