param(
    [string]$GodotBin = $env:GODOT_BIN,
    [switch]$SkipExport
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($GodotBin)) {
    $godotCommand = Get-Command godot -ErrorAction SilentlyContinue
    if ($null -eq $godotCommand) {
        Write-Error "Godot was not found. Add Godot to PATH or run with -GodotBin 'C:\path\to\Godot.exe'."
    }
    $GodotBin = $godotCommand.Source
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$buildPath = Join-Path $repoRoot "build\web\index.html"

Write-Host "Using Godot: $GodotBin"
Write-Host "Checking main scene..."
& $GodotBin --headless --path $repoRoot --scene "res://scenes/Main.tscn" --quit-after 5
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

if ($SkipExport) {
    Write-Host "Skipping web export."
    exit 0
}

Write-Host "Checking Web export..."
New-Item -ItemType Directory -Force -Path (Split-Path $buildPath) | Out-Null
& $GodotBin --headless --path $repoRoot --export-release Web $buildPath
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Godot verification passed."
