# Sound: Disable Startup Sound: Enable: 0, Disable: 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\EditionOverrides" "UserSetting_DisableStartupSound" 1

$defaultImagePath =
$personalizationKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization'
if (!(Test-Path -Path $personalizationKey)) { $null = New-Item -Path $personalizationKey }

# Disable lockscreen
Set-ItemProperty $personalizationKey "NoLockScreen" 1

# Enable Custom Background on the Login / Lock Screen, File Size Limit: 256Kb
Set-ItemProperty $personalizationKey "LockScreenImage" "$PSScriptRoot\images\black.png"
