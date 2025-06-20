# Find the project root by looking for package.json
function Get-ProjectRoot {
    $dir = Resolve-Path "."
    while ($dir -and -not (Test-Path (Join-Path $dir "package.json"))) {
        $parent = Split-Path $dir
        if ($parent -eq $dir) { return $null }
        $dir = $parent
    }
    return $dir
}

$projectRoot = Get-ProjectRoot
if (-not $projectRoot) {
    Write-Error "Could not find project root (missing package.json)"
    exit 1
}

$envFile = Join-Path $projectRoot ".vaultenv"

# Try to load env
if (Test-Path $envFile) {
    $lines = Get-Content $envFile | Where-Object { $_ -match '=' }
    foreach ($line in $lines) {
        $parts = $line -split '=', 2
        if ($parts[0].Trim() -eq "SOURCE_PATH") {
            $source = $parts[1].Trim()
        }
    }
}

# Prompt if undefined or empty
if (-not $source -or $source.Trim() -eq '') {
    $source = Read-Host "Please enter full path to the Obsidian Vault"

    if (-not (Test-Path $source)) {
        Write-Error "Source path '$source' does not exist."
        exit 1
    }

    # Save to .vaultenv
    "SOURCE_PATH=$source" | Set-Content -Encoding UTF8 $envFile
    Write-Host "--> Saved source path to .vaultenv" -ForegroundColor Green
}

$destination = Join-Path $projectRoot "content"

Write-Host "==> Starting sync from '$source' to '$destination'" -ForegroundColor Cyan

if (Test-Path $destination) {
    Write-Host "--> Removing existing content folder..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $destination
}

Write-Host "--> Creating destination folder..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $destination | Out-Null

Write-Host "--> Copying files..." -ForegroundColor Cyan
Get-ChildItem -Path $source | ForEach-Object {
    $targetPath = Join-Path -Path $destination -ChildPath $_.Name
    Copy-Item -Path $_.FullName -Destination $targetPath -Recurse -Force
}

Write-Host "==> Sync complete!" -ForegroundColor Green