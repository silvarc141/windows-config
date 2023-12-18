Write-Host "Installing Packages..." -ForegroundColor "Yellow"

# core
winget install AgileBits.1Password --silent --accept-package-agreements
scoop install main/1password-cli
scoop install main/rclone
scoop install extras/glazewm

# fonts
scoop install nerd-fonts/codenewroman-nf
scoop install nerd-fonts/cascadiaCode-nf-mono
scoop install nerd-fonts/JetbrainsMono-nf-mono

# basic
scoop install main/7zip
scoop install extras/alacritty
scoop install extras/firefox
scoop install extras/vscodium
scoop install extras/vlc
scoop install extras/f3d
scoop install extras/honeyview
scoop install extras/libreoffice
scoop install extras/sharex

# communication
winget install Discord.Discord --silent --accept-package-agreements
winget install Vendicated.Vencord --silent --accept-package-agreements
winget install Readdle.Spark --silent --accept-package-agreements
winget install NovaTechnology.Beeper --silent --accept-package-agreements
winget install Microsoft.Teams --silent --accept-package-agreements

# workflow
scoop install extras/autohotkey
scoop install extras/glazewm
scoop install extras/everything
scoop install extras/fluent-search
scoop install extras/obsidian
#scoop install main/gsudo
#scoop install extras/copyq

# dev
scoop install main/rustup
scoop install main/neovim
scoop install main/vim
scoop install main/vimtutor
scoop install extras/rider
scoop install extras/sourcetree

# media
scoop install main/ffmpeg
scoop install main/yt-dlp
scoop install extras/reaper
scoop install extras/handbrake
scoop install extras/losslesscut
scoop install extras/gimp
scoop install extras/krita
scoop install extras/blender
scoop install extras/inkscape
scoop install extras/obs-studio

# games
winget install Valve.Steam --silent --accept-package-agreements
winget install EpicGames.EpicGamesLauncher --silent --accept-package-agreements
winget install Battle.net --silent --accept-package-agreements

# themeing
scoop install main/neofetch
scoop install main/starship
scoop install extras/micaforeveryone
scoop install extras/secureuxtheme
scoop install extras/7tsp
#scoop install extras/roundedtb
#scoop install extras/translucenttb
#scoop install extras/rainmeter
#scoop install extras/lively
#scoop install extras/eartrumpet

# other
winget install Oracle.VirtualBox --silent --accept-package-agreements
scoop install extras/powertoys
scoop install extras/etcher
scoop install extras/ventoy
scoop install extras/droidcam

# hardware specific
winget install Nvidia.GeForceExperience --silent --accept-package-agreements
winget install 9WZDNCRFHWLH --silent --accept-package-agreements # HP Smart
scoop install extras/logitech-omm


#winget install Microsoft.VisualStudio.2022.Enterprise --silent --accept-package-agreements
# winget install Microsoft.VisualStudio.2022.Enterprise  --silent --accept-package-agreements --override "--wait --quiet --norestart --nocache --addProductLang En-us --add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetWeb"
# winget install Microsoft.VisualStudio.2022.Professional  --silent --accept-package-agreements --override "--wait --quiet --norestart --nocache --addProductLang En-us --add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetWeb"
# winget install JetBrains.dotUltimate                     --silent --accept-package-agreements --override "/SpecificProductNames=ReSharper;dotTrace;dotCover /Silent=True /VsVersion=17.0"


<# problematic:
Unity
Plastic SCM Enterprise
#>

<# dependencies
Microsoft.VCRedist.2005.x86
Microsoft.VCRedist.2010.x86
Microsoft.VCRedist.2013.x64
Microsoft.VCRedist.2015+.x64
Microsoft.DotNet.SDK.3_1
Python.Python.3.8
#>

<# registry
reg import "C:\Users\Marta\scoop\apps\eartrumpet\current\add-startup.reg"

"C:\Users\Marta\scoop\apps\7zip\current\install-context.reg"

Add VSCodium as a context menu option by running: 'reg import
"C:\Users\Marta\scoop\apps\vscodium\current\install-context.reg"'
For file associations, run 'reg import
"C:\Users\Marta\scoop\apps\vscodium\current\install-associations.reg"'

Set Git Credential Manager Core by running: "git config --global credential.helper manager"
To add context menu entries, run 'C:\Users\Marta\scoop\apps\git\current\install-context.reg'
To create file-associations for .git* and .sh files, run
'C:\Users\Marta\scoop\apps\git\current\install-file-associations.reg'

"C:\Users\Marta\scoop\apps\python\current\install-pep-514.reg"
#>