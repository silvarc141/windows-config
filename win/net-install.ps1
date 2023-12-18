$account = "silvarc141"
$repo    = "os-setup"
$branch  = "main"
$os = "win"

function Download-File {
    param (
      [string]$url,
      [string]$file
    )
    Write-Host "Downloading $url to $file"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $url -OutFile $file
  }
  
  function Unzip-File {
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
          } catch {
              Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
          }
      } else {
          try {
              $shell = New-Object -ComObject Shell.Application
              $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
          } catch {
              Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
          }
      }
  }

$tempDir = "$env:TEMP\$repo"
New-Item -ItemType Directory -Path $tempDir -Force
$zip = "$tempDir\$repo.zip"
$installDir = "$tempDir\$repo-$branch\$os"

Write-Host "Downloading installation files..." -ForegroundColor "Yellow"
Download-File "https://github.com/$account/$repo/archive/$branch.zip" $zip
if(Test-Path $installDir) { Remove-Item -Path $installDir -Recurse -Force }
Unzip-File $zip $tempDir

Push-Location $installDir
Start-Process powershell.exe -NoNewWindow -Wait -ArgumentList ".\install-all.ps1"
Pop-Location

Write-Host "Removing installation files..." -ForegroundColor "Yellow"
Remove-Item -Path $tempDir -Recurse -Force

#Write-Host "Restarting..." -ForegroundColor "Yellow"
#shutdown /r /t 0 