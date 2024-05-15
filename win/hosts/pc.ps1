(new-object net.webclient).DownloadString("https://raw.github.com/silvarc141/os-setup/main/win/run-script-in-repo-context") | Invoke-Expression
Run-ScriptInRepoContext -Account silvarc141 -Repo os-setup -Branch main -RunPath win
