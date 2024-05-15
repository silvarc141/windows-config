$toEnsure = @(
'projects',
'downloads',
'software',
'sync',
'workspace',
'pictures',
'videos',
'music'
)

$notWorthRemoving = @(
'Desktop',
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

# Ensure correctly named folders
foreach ($fileName in $toEnsure) {
    if (Test-Path $HOME\$fileName) {
        $item = Get-Item -Force $HOME\$fileName

        # Not hidden
        $item.Attributes = $item.Attributes -band (-bnot [System.IO.FileAttributes]::Hidden)

        # Correct case
        if ($item.Name -cne $fileName) {Rename-Item $item $fileName}
    }
    else {
        New-Item -ItemType Directory $HOME\$fileName | Out-Null
    }
}

# Remove unneeded folders
foreach($fileName in $toRemove) {
    if (Test-Path $HOME\$fileName) {
        Get-Item -Force $HOME\$fileName | ForEach-Object { Remove-Item -Force $_ }
    }
}

# Hide folders that are unneeded but problematic to remove
foreach($fileName in $notWorthRemoving) {
    if (Test-Path $HOME\$fileName) {
        $item = Get-Item -Force $HOME\$fileName
        $item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::Hidden
    }
}

# Hide dotfiles
foreach ($item in Get-ChildItem -Path $HOME | Where-Object { $_.Name -match '[\._].*'}) {
    $item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::Hidden
}
