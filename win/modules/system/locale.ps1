Write-Host "Configuring Locale..." -ForegroundColor "Yellow"

# Target language list
$languages = @("en-US", "pl-PL")

# No installed language can result in a boot loop
if ([string]::IsNullOrEmpty($languages)) { $languages = @("en-US") }

# Install missing languages from the list
$installed = Get-InstalledLanguage | Foreach-Object { $_.LanguageId }
$languages | Foreach-Object { if ($installed -notcontains $_) {
            Write-Host "Installing requested language: $_"
            Install-Language $_
      } }

# Uninstall languages not on the list
$installed | Foreach-Object { if ($languages -notcontains $_) {
            Write-Host "Uninstalling unnecessary language: $_"
            Uninstall-Language $_
      } }

# Set input language
Set-WinUserLanguageList $languages -Force

# Override default input method
Set-WinDefaultInputMethodOverride -InputTip "0415:00000415" #pl

# Set display language (applied after sign-in)
$displayLanguage = $languages[0]
Set-WinUILanguageOverride $displayLanguage
Set-WinSystemLocale -SystemLocale $displayLanguage
Set-SystemPreferredUILanguage -Language $displayLanguage

# Set culture for date format etc
# https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-lcid/a9eac961-e77d-41a6-90a5-ce1a8b0cdb9c
Set-Culture en-150 #English (Europe)

# Set geographical region
# https://learn.microsoft.com/en-us/windows/win32/intl/table-of-geographical-locations
Set-WinHomeLocation -GeoId 244 #United States

# Set timezone
Set-TimeZone -Name "Central European Standard Time"
