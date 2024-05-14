Write-Host "Updating Winget..." -ForegroundColor "Yellow"

$results = (winget --version) | Select-String -Pattern 'v(\d)\.(\d).*'
$major = $results.Matches.Groups[1].Captures.Value -le 1
$minor = $results.Matches.Groups[2].Captures.Value -lt 6

if ($major -and $minor) {
    $API_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $DOWNLOAD_URL = $(Invoke-RestMethod $API_URL).assets.browser_download_url | Where-Object { $_.EndsWith(".msixbundle") }
    Invoke-WebRequest -URI $DOWNLOAD_URL -OutFile winget.msixbundle -UseBasicParsing
    Add-AppxPackage winget.msixbundle
    Remove-Item winget.msixbundle
}
else {
    winget upgrade winget --silent --accept-package-agreements --accept-source-agreements
}
