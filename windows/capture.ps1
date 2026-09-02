# Pull the live Windows config back into this repo, after editing any of it in
# place.
#
#   powershell -ExecutionPolicy Bypass -File windows\capture.ps1
#
# apply.ps1 goes the other way. Windows Terminal rewrites its settings.json in
# its own format whenever you change something in its UI, so expect noise in
# that diff.

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$sources = @{
    "wezterm.lua"                    = "$env:USERPROFILE\.wezterm.lua"
    "nomouse.ahk"                    = "$env:USERPROFILE\.config\ahk\nomouse.ahk"
    "windows-terminal-settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
}

foreach ($name in $sources.Keys) {
    $src = $sources[$name]
    $dst = Join-Path $here $name

    if (-not (Test-Path $src)) {
        Write-Host "skip $name - not on this machine"
        continue
    }

    Copy-Item $src $dst -Force
    Write-Host "captured $name"
}

Write-Host ""
Write-Host "Commit from inside WSL:"
Write-Host "  cd ~/.dotfiles && git add -A && git commit && git push"
