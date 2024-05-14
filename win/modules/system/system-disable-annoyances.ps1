# SSD: Disable SuperFetch: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" 0

# Network: Disable WiFi Sense: Enable: 1, Disable: 0
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" "AutoConnectAllowedOEM" 0
