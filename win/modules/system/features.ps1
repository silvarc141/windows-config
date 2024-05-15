# Enable Developer Mode: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" "AllowDevelopmentWithoutDevLicense" 1

# Enable long paths
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1

# Install WSL
$featureName = "Microsoft-Windows-Subsystem-Linux"
$featureObject = Get-WindowsOptionalFeature -Online -FeatureName $featureName

if ($($null -eq $featureObject) -or $($featureObject.State -ne 'Enabled')) {
      Enable-WindowsOptionalFeature -Online -All -FeatureName $featureName -NoRestart -WarningAction SilentlyContinue | Out-Null
}

# Install media feature pack (for Windows N versions)
#Get-WindowsCapability -online | Where-Object -Property name -like "*MediaFeaturePack*" | Add-WindowsCapability -Online | Out-Null
