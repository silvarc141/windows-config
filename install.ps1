param(
    [string]$Config = 'default',
    [switch]$BypassSystem,
    [switch]$BypassUser,
    [switch]$Reboot,
    [switch]$RestartExplorer,
    [switch]$Local,
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

if($Local)
{
    $rootDirectory = $PSScriptRoot
}
else
{
    $tempDirectory = "$env:TEMP\$Repo"
    $zipFilePath = "$tempDirectory\$Repo.zip"
    $rootDirectory = "$tempDirectory\$Repo-$Branch"

    if (Test-Path $tempDirectory) {
        Write-Host "Removing leftover temporary files..." -ForegroundColor "Yellow"
        Remove-Item -Path $tempDirectory -Recurse -Force
    }

    Write-Host "Creating temporary directory..." -ForegroundColor "Yellow"
    New-Item -ItemType Directory -Path $tempDirectory -Force | Out-Null

    Write-Host "Downloading repo files..." -ForegroundColor "Yellow"
    Get-FileFromUrl "https://github.com/$Account/$Repo/archive/$Branch.zip" $zipFilePath

    Write-Host "Unpacking..." -ForegroundColor "Yellow"
    Get-UnzippedContentFromFile $zipFilePath $tempDirectory
}

$configsDirectory = "$rootDirectory\configs"
$configPathDefault = "$configsDirectory\default.json"
$configPath = "$configsDirectory\$Config.json"
if(!(Test-Path $configPath)) { $configPath = $configPathDefault }
$configObject = Get-Content -Raw -Path $configPath | ConvertFrom-Json
if($configObject -eq $null) { $configObject = Get-Content -Raw -Path $configPathDefault}

if(!$BypassSystem)
{
    Write-Host "Installing system configuration..." -ForegroundColor "Yellow"
    #Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList "$rootDirectory\installers\system-installer.ps1"
    & "$rootDirectory\installers\system-installer.ps1" $configObject
}

if(!$BypassUser)
{
    Write-Host "Installing user configuration..." -ForegroundColor "Yellow"
    #Start-Process powershell.exe -Wait -NoNewWindow -ArgumentList "$rootDirectory\installers\user-installer.ps1"
    & "$rootDirectory\installers\user-installer.ps1" $configObject
}

Write-Host "Finalizing..." -ForegroundColor "Yellow"
if(!$Local) { Remove-Item -Path $tempDirectory -Recurse -Force }
if($RestartExplorer) { Stop-Process -ProcessName explorer -Force }
if($Reboot) { shutdown /r /t 0 }
