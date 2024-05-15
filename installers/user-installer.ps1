param($ConfigObject)

function Install-ScoopPackage {
    param (
        $name
    )

    Write-Host "`nInstalling $($name)"
    scoop install $name
    scoop update $name
}

Write-Host "`nProcessing user configuration modules..." -ForegroundColor "Yellow"
foreach($item in Get-ChildItem "$PSScriptRoot\..\modules\user\") {
    Write-Host "Configuring $([System.IO.Path]::GetFileNameWithoutExtension($item))" -ForegroundColor "Yellow"
    . $item.FullName
}

Write-Host "`nSetting up Scoop..." -ForegroundColor "Yellow"
$HoldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
$ErrorActionPreference = $HoldErrorActionPreference

if (![Boolean](Get-Command scoop -ErrorAction SilentlyContinue)) {
    "$(Invoke-RestMethod get.scoop.sh)" | Invoke-Expression
}

scoop bucket add extras | Out-Null
scoop bucket add nerd-fonts | Out-Null
scoop bucket add sysinternals | Out-Null
scoop bucket add games | Out-Null
#scoop bucket add DEV-tools https://github.com/anderlli0053/DEV-tools.git
scoop update

Write-Host "`nInstalling installation dependencies..." -ForegroundColor "Yellow"

@("main/aria2", "main/chezmoi") | ForEach-Object { Install-ScoopPackage $_ }

if (![Boolean](Get-Command git -ErrorAction SilentlyContinue)) {
    Install-ScoopPackage "main/git"
}

Write-Host "`nInstalling dotfiles..." -ForegroundColor "Yellow"
chezmoi init $ConfigObject.dotfiles --force --keep-going
chezmoi update --force --keep-going
scoop update # remove when dotfiles ignore scoop update date

Write-Host "`nInstalling packages..." -ForegroundColor "Yellow"

foreach ($package in $ConfigObject.packages) {
    if ($package.manager -eq 'scoop') { Install-ScoopPackage $package.id }
}

Write-Host "`nReapplying dotfiles after installation..." -ForegroundColor "Yellow"
chezmoi update --force --keep-going

Write-Host "`nRemoving user startup apps..." -ForegroundColor "Yellow"
("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
"HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce") |
ForEach-Object { @{Path = $_; Item = Get-Item -Path $_ } } |
Where-Object { $_.Item.ValueCount -ne 0 } |
ForEach-Object { Remove-ItemProperty -Path $_.Path -Name $_.Item.Property }

Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\*" -Force
