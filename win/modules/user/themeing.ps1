# Titlebar: Disable theme colors on titlebar: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\DWM" "ColorPrevalence" 1

# Set classic Control Panel to small icons
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel")) { New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" | Out-Null }
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" -Name "StartupPage" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" -Name "AllItemsIconView" -Type DWord -Value 1

# Desktop: Hide desktop icons: Show: 0, Hide: 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideIcons" 1

# Light mode: 1, Dark mode: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 0

# Taskbar: Remove pinned
Remove-Item -Path "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Force -Recurse -ErrorAction SilentlyContinue

# Taskbar: Auto hide taskbar: Enable: 3, Disable: 2
# Needs explorer restart to apply
$autoHide = 3
$path = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$value = (Get-ItemProperty -Path $path).Settings
$value[8] = $autoHide;
Set-ItemProperty -Path $path -Name Settings -Value $value

# Taskbar: Show colors on Taskbar, Start, and SysTray: Disabled: 0, Taskbar, Start, & SysTray: 1, Taskbar Only: 2
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "ColorPrevalence" 1

# Taskbar: Hide the Search, Task, Widget, and Chat buttons: Show: 1, Hide: 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0  # Search
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 0 # Task
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" 0 # Widgets
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 0 # Chat
