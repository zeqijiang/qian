# Export Windows play-build (no Godot required on player PC)
# Prerequisites:
#   1) Godot 4.4.1 at $GodotExe (default: C:\Users\admin\tools\Godot_v4.4.1-stable_win64_console.exe)
#   2) Export templates installed to:
#      %APPDATA%\Godot\export_templates\4.4.1.stable\
#      (download Godot_v4.4.1-stable_export_templates.tpz and extract "templates" folder there)
param(
  [string]$GodotExe = "C:\Users\admin\tools\Godot_v4.4.1-stable_win64_console.exe",
  [string]$ProjectDir = "C:\Users\admin\XiaomiMiMoProjects\spirit-revival-fighting",
  [string]$OutDir = "C:\Users\admin\XiaomiMiMoProjects\dist\spirit-revival-fighting"
)

$ErrorActionPreference = "Stop"
$version = "4.4.1.stable"
$tpl = Join-Path $env:APPDATA "Godot\export_templates\$version"
if (-not (Test-Path $tpl)) {
  Write-Host "Missing export templates at: $tpl"
  Write-Host "Download: https://godotengine.org/download/archive/ (4.4.1-stable Export templates)"
  Write-Host "Extract tpz so windows_release_x86_64.exe exists under that folder."
  exit 1
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
Push-Location $ProjectDir
& $GodotExe --headless --path . --export-release "Windows Desktop" (Join-Path $OutDir "SpiritRevivalFighting.exe")
$code = $LASTEXITCODE
Pop-Location
Write-Host "Export exit: $code"
if (Test-Path (Join-Path $OutDir "SpiritRevivalFighting.exe")) {
  Write-Host "OK: $OutDir\SpiritRevivalFighting.exe"
  $zip = "C:\Users\admin\XiaomiMiMoProjects\SpiritRevivalFighting-win64.zip"
  if (Test-Path $zip) { Remove-Item $zip -Force }
  Compress-Archive -Path $OutDir -DestinationPath $zip
  Write-Host "ZIP: $zip"
} else {
  Write-Host "Export failed — see Godot output above."
  exit 1
}
