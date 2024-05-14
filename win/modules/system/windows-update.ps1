Write-Host "Configuring Windows Update..." -ForegroundColor "Yellow"

# Disable automatic reboot after install: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "IsExpedited" 0

# Disable restart required notifications: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "RestartNotificationsAllowed2" 0

# Disable updates over metered connections: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "AllowAutoWindowsUpdateDownloadOverMeteredNetwork" 0

# Opt-In to Microsoft Update
$MU = New-Object -ComObject Microsoft.Update.ServiceManager -Strict
$MU.AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "") | Out-Null
Remove-Variable MU
