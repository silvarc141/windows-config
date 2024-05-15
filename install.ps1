param(
    [string]$Config = 'default',
    [bool]$InstallSystem = $True,
    [bool]$InstallUser = $True,
    [bool]$Reboot = $False,
    [bool]$RestartExplorer = $True,
    [string]$Account = 'silvarc141',
    [string]$Repo = 'windows-config',
    [string]$Branch = 'main'
)

function Get-FileFromUrl {
    param (
        [string]$url,
        [string]$file
    )

    Write-Host "Downloading $url to $file"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $url -OutFile $file
}

function Get-UnzippedContentFromFile {
    param (
        [string]$File,
        [string]$Destination = (Get-Location).Path
    )

    $filePath = Resolve-Path $File
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

    If (($PSVersionTable.PSVersion.Major -ge 3) -and
        (
            [version](Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -ge [version]"4.5" -or
            [version](Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -ge [version]"4.5"
        )) {
        try {
            [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
        }
        catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
    else {
        try {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
        }
        catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
}

$tempDir = "$env:TEMP\$Repo"
$zipFilePath = "$tempDir\$Repo.zip"

if (Test-Path $tempDir) {
    Write-Host "Removing leftover temporary files..." -ForegroundColor "Yellow"
    Remove-Item -Path $tempDir -Recurse -Force
}

Write-Host "Creating temporary directory..." -ForegroundColor "Yellow"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

Write-Host "Downloading repo files..." -ForegroundColor "Yellow"
Get-FileFromUrl "https://github.com/$Account/$Repo/archive/$Branch.zip" $zipFilePath

Write-Host "Unpacking..." -ForegroundColor "Yellow"
Get-UnzippedContentFromFile $zipFilePath $tempDir

$configPathBase = "$PSScriptRoot\configs"
$configPathDefault = "$configPathBase\default.json"
$configPath = "$configPathBase\$Config.json"
if(!(Test-Path $configPath)) { $configPath = $configPathDefault }
$configObject = Get-Content -Raw -Path $configPath | ConvertFrom-Json
if($configObject -eq $null) { $configObject = Get-Content -Raw -Path $configPathDefault}

if($InstallSystem)
{
    Write-Host "Installing system configuration..." -ForegroundColor "Yellow"
    Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList .\system-install.ps1
}

if($InstallUser)
{
    Write-Host "Installing user configuration..." -ForegroundColor "Yellow"
    Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList .\user-install.ps1
}

Write-Host "Finalizing..." -ForegroundColor "Yellow"
Remove-Item -Path $tempDir -Recurse -Force
if($RestartExplorer) { Stop-Process -ProcessName explorer -Force }
if($Reboot) { shutdown /r /t 0 }
