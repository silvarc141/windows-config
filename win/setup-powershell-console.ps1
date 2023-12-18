###############################################################################
### PowerShell Console                                                        #
###############################################################################
Write-Host "Configuring Console..." -ForegroundColor "Yellow"

# Make 'Source Code Pro' an available Console font
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' 000 'Source Code Pro'

@(`
"HKCU:\Console\%SystemRoot%_System32_bash.exe",`
"HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe",`
"HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe",`
"HKCU:\Console\Windows PowerShell (x86)",`
"HKCU:\Console\Windows PowerShell",`
"HKCU:\Console"`
) | ForEach {
    If (!(Test-Path $_)) {
        New-Item -path $_ -ItemType Folder | Out-Null
    }

# Dimensions of window, in characters: 8-byte; 4b height, 4b width. Max: 0x7FFF7FFF (32767h x 32767w)
Set-ItemProperty $_ "WindowSize"           0x002D0078 # 45h x 120w
# Dimensions of screen buffer in memory, in characters: 8-byte; 4b height, 4b width. Max: 0x7FFF7FFF (32767h x 32767w)
Set-ItemProperty $_ "ScreenBufferSize"     0x0BB80078 # 3000h x 120w
# Percentage of Character Space for Cursor: 25: Small, 50: Medium, 100: Large
Set-ItemProperty $_ "CursorSize"           100
# Name of display font
Set-ItemProperty $_ "FaceName"             "Source Code Pro"
# Font Family: Raster: 0, TrueType: 54
Set-ItemProperty $_ "FontFamily"           54
# Dimensions of font character in pixels, not Points: 8-byte; 4b height, 4b width. 0: Auto
Set-ItemProperty $_ "FontSize"             0x00110000 # 17px height x auto width
# Boldness of font: Raster=(Normal: 0, Bold: 1), TrueType=(100-900, Normal: 400)
Set-ItemProperty $_ "FontWeight"           400
# Number of commands in history buffer
Set-ItemProperty $_ "HistoryBufferSize"    50
# Discard duplicate commands
Set-ItemProperty $_ "HistoryNoDup"         1
# Typing Mode: Overtype: 0, Insert: 1
Set-ItemProperty $_ "InsertMode"           1
# Enable Copy/Paste using Mouse
Set-ItemProperty $_ "QuickEdit"            1
# Background and Foreground Colors for Window: 2-byte; 1b background, 1b foreground; Color: 0-F
Set-ItemProperty $_ "ScreenColors"         0x0F
# Background and Foreground Colors for Popup Window: 2-byte; 1b background, 1b foreground; Color: 0-F
Set-ItemProperty $_ "PopupColors"          0xF0
# Adjust opacity between 30% and 100%: 0x4C to 0xFF -or- 76 to 255
Set-ItemProperty $_ "WindowAlpha"          0xF2

# The 16 colors in the Console color well (Persisted values are in BGR).
# Theme: Jellybeans
Set-ItemProperty $_ "ColorTable00"         $(Convert-ConsoleColor "#151515") # Black (0)
Set-ItemProperty $_ "ColorTable01"         $(Convert-ConsoleColor "#8197bf") # DarkBlue (1)
Set-ItemProperty $_ "ColorTable02"         $(Convert-ConsoleColor "#437019") # DarkGreen (2)
Set-ItemProperty $_ "ColorTable03"         $(Convert-ConsoleColor "#556779") # DarkCyan (3)
Set-ItemProperty $_ "ColorTable04"         $(Convert-ConsoleColor "#902020") # DarkRed (4)
Set-ItemProperty $_ "ColorTable05"         $(Convert-ConsoleColor "#540063") # DarkMagenta (5)
Set-ItemProperty $_ "ColorTable06"         $(Convert-ConsoleColor "#dad085") # DarkYellow (6)
Set-ItemProperty $_ "ColorTable07"         $(Convert-ConsoleColor "#888888") # Gray (7)
Set-ItemProperty $_ "ColorTable08"         $(Convert-ConsoleColor "#606060") # DarkGray (8)
Set-ItemProperty $_ "ColorTable09"         $(Convert-ConsoleColor "#7697d6") # Blue (9)
Set-ItemProperty $_ "ColorTable10"         $(Convert-ConsoleColor "#99ad6a") # Green (A)
Set-ItemProperty $_ "ColorTable11"         $(Convert-ConsoleColor "#c6b6ee") # Cyan (B)
Set-ItemProperty $_ "ColorTable12"         $(Convert-ConsoleColor "#cf6a4c") # Red (C)
Set-ItemProperty $_ "ColorTable13"         $(Convert-ConsoleColor "#f0a0c0") # Magenta (D)
Set-ItemProperty $_ "ColorTable14"         $(Convert-ConsoleColor "#fad07a") # Yellow (E)
Set-ItemProperty $_ "ColorTable15"         $(Convert-ConsoleColor "#e8e8d3") # White (F)
}

# Customizing PoSh syntax
# Theme: Jellybeans
Set-PSReadlineOption -Colors @{
    "Default"   = "#e8e8d3"
    "Comment"   = "#888888"
    "Keyword"   = "#8197bf"
    "String"    = "#99ad6a"
    "Operator"  = "#c6b6ee"
    "Variable"  = "#c6b6ee"
    "Command"   = "#8197bf"
    "Parameter" = "#e8e8d3"
    "Type"      = "#fad07a"
    "Number"    = "#cf6a4c"
    "Member"    = "#fad07a"
    "Emphasis"  = "#f0a0c0"
    "Error"     = "#902020"
}

# Remove property overrides from PowerShell and Bash shortcuts
Reset-AllPowerShellShortcuts
Reset-AllBashShortcuts