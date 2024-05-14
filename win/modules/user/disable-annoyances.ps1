# Disable Xbox gamebar system calls (ms-gamingoverlay): Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled" -Type Dword -Value 0
Set-ItemProperty "HKCU:\System\GameConfigStore" "GameDVR_Enabled" -Type Dword -Value 0
