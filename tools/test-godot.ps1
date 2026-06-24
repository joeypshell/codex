param(
    [string]$GodotBin = $env:GODOT_BIN
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

Write-Host "Using Godot: $GodotBin"
Write-Host "Running rule tests..."
& $GodotBin --headless --path $repoRoot --script "res://tests/rule_tests.gd"
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Godot tests passed."
