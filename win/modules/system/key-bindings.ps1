# Rebind keys

if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"))
{
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" | Out-Null
}

$binds = @(0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0, # header
0x2,0x0,0x0,0x0, # how many entries including null entry
0x58,0x0,0x5b,0xe0, # entry: left windows key (0xe05b) to F12 (0x58)
0x0,0x0,0x0,0x0) # null entry
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -Type Binary -Value $binds
