. { (new-object net.webclient).DownloadString("https://raw.github.com/silvarc141/os-setup/main/run-install-script-in-context.ps1") | Invoke-Expression }
Run-InstallScriptInContext -Account silvarc141 -Repo os-setup -Branch main
