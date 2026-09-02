# Deploy the Windows half of this repo onto this machine.
#
#   powershell -ExecutionPolicy Bypass -File windows\apply.ps1
#
# The Linux half is handled by home-manager. These three files cannot be,
# because they live on the Windows side of the machine:
#
#   wezterm.lua                     -> %USERPROFILE%\.wezterm.lua
#   nomouse.ahk                     -> %USERPROFILE%\.config\ahk\nomouse.ahk
#   windows-terminal-settings.json  -> Windows Terminal LocalState
#
# Run capture.ps1 to go the other way, after editing any of them in place.

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$targets = @{
    "wezterm.lua"                    = "$env:USERPROFILE\.wezterm.lua"
    "nomouse.ahk"                    = "$env:USERPROFILE\.config\ahk\nomouse.ahk"
    "windows-terminal-settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
}

foreach ($name in $targets.Keys) {
    $src = Join-Path $here $name
    $dst = $targets[$name]

    if (-not (Test-Path $src)) {
        Write-Host "skip $name - not in the repo"
        continue
    }

    $parent = Split-Path -Parent $dst
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    # Keep one backup of whatever was there, so a bad deploy is recoverable.
    if (Test-Path $dst) {
        Copy-Item $dst "$dst.bak" -Force
    }

    Copy-Item $src $dst -Force
    Write-Host "applied $name -> $dst"
}

Write-Host ""
Write-Host "WezTerm and Windows Terminal reload settings on their own."
Write-Host "AutoHotkey does not - restart it to pick up nomouse.ahk:"
Write-Host '  Get-Process AutoHotkey* | Stop-Process -Force'
Write-Host '  Start-Process "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe" -ArgumentList "$env:USERPROFILE\.config\ahk\nomouse.ahk"'
