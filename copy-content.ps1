$source = "E:\Projects\hunter-unveiled"
$destination = "E:\Projects\graham-case-files\content"

Write-Host "==> Starting sync from '$source' to '$destination'" -ForegroundColor Cyan

# Step 1: Remove old content folder if it exists
if (Test-Path $destination) {
    Write-Host "--> Removing existing content folder..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $destination
} else {
    Write-Host "--> No existing content folder found. Proceeding..." -ForegroundColor Green
}

# Step 2: Recreate the content folder
Write-Host "--> Creating destination folder..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $destination | Out-Null

# Step 3: Copy each item (file/folder) individually to avoid container/leaf issues
Write-Host "--> Copying files..." -ForegroundColor Cyan
Get-ChildItem -Path $source | ForEach-Object {
    $targetPath = Join-Path -Path $destination -ChildPath $_.Name
    Copy-Item -Path $_.FullName -Destination $targetPath -Recurse -Force
}

Write-Host "==> Sync complete!" -ForegroundColor Green
