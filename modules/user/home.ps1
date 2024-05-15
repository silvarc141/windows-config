$toEnsure = @(
'projects',
'downloads',
'software',
'sync',
'desktop',
'pictures',
'videos',
'music'
)

$notWorthRemoving = @(
'Documents',
'Saved Games',
'Favorites',
'Contacts',
'Searches',
'Tracing'
)

$toRemove = @(
'OneDrive'
)

foreach ($fileName in $toEnsure) {
    if (Test-Path $HOME\$fileName)
    {
        $item = Get-Item -Force $HOME\$fileName

        # Not hidden
        $item.Attributes = $item.Attributes -band (-bnot [System.IO.FileAttributes]::Hidden)

        # Correct case
        if ($item.Name -cne $fileName) {Rename-Item $item $fileName}
    }
    else
    {
        New-Item -ItemType Directory $HOME\$fileName
    }
}

foreach($fileName in $notWorthRemoving)
{
    if (Test-Path $HOME\$fileName)
    {
        $item = Get-Item -Force $HOME\$fileName
        $item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::Hidden
    }
}

foreach($fileName in $toRemove)
{
    if (Test-Path $HOME\$fileName)
    {
        Get-Item -Force $HOME\$fileName | ForEach-Object { Remove-Item -Force $_ }
    }
}
