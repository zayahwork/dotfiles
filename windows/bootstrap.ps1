# Stand this repo up on a Windows machine that has never run it.
#
#   powershell -ExecutionPolicy Bypass -File windows\bootstrap.ps1
#
# Idempotent. Every step checks before it acts, so a second run on a machine
# that is already set up installs nothing and still reports what it found.
#
# home-manager owns the Linux side and cannot touch any of this: the terminal,
# the font, the key layer and the launch hotkey all live on Windows. A switch
# that reports success while none of this is here is the single most expensive
# failure in library/bootstrap.md, and this script is the answer to it.
#
# The Linux half is bootstrap.sh, which this hands off to at the end.

$ErrorActionPreference = "Stop"

$distro = "Ubuntu"
$repoLinux = "~/github/dotfiles"
$remote = "https://github.com/zayahwork/dotfiles.git"

function Say($msg) { Write-Host ""; Write-Host "== $msg" -ForegroundColor Cyan }
function Ok($msg)  { Write-Host "   $msg" }

# --------------------------------------------------------------- prereqs --
Say "prerequisites"

if (-not (Get-Command wsl -ErrorAction SilentlyContinue)) {
    throw "WSL is not installed. Install it, add Ubuntu, then run this again."
}

# Docker Desktop registers its own distro and takes the default marker, so a
# bare `wsl` lands somewhere with no shell at all. Everything here is explicit.
$distros = (wsl -l -q) -replace "`0", "" | ForEach-Object { $_.Trim() } |
    Where-Object { $_ }
if ($distros -notcontains $distro) {
    throw "WSL distro '$distro' not found. Installed: $($distros -join ', ')"
}
Ok "wsl: $distro present"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is not available; install App Installer from the Store."
}
Ok "winget: present"

# ------------------------------------------------------- windows packages --
Say "windows packages"

$packages = @(
    @{ Id = "AutoHotkey.AutoHotkey";        Name = "AutoHotkey v2" }
    @{ Id = "wez.wezterm";                  Name = "WezTerm" }
    @{ Id = "DEVCOM.JetBrainsMonoNerdFont"; Name = "JetBrainsMono Nerd Font" }
)

foreach ($p in $packages) {
    winget list --id $p.Id --exact --accept-source-agreements *> $null
    if ($LASTEXITCODE -eq 0) {
        Ok "$($p.Name): already installed"
        continue
    }

    Write-Host "   installing $($p.Name)..."
    winget install --id $p.Id --exact --source winget `
        --accept-package-agreements --accept-source-agreements `
        --silent --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "   $($p.Name) did not install (exit $LASTEXITCODE); carrying on"
    } else {
        Ok "$($p.Name): installed"
    }
}

# ------------------------------------------------- the three config files --
Say "deploying the windows half"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$applyPs1 = Join-Path $here "apply.ps1"

if (Test-Path $applyPs1) {
    & powershell -ExecutionPolicy Bypass -File $applyPs1
} else {
    Write-Warning "apply.ps1 not beside this script; skipping the file deploy"
}

# ------------------------------------------------------- autohotkey layer --
Say "the key layer"

# winget installs machine-wide, so it lands in Program Files. The hint printed
# by apply.ps1 points at LOCALAPPDATA and is wrong; check both rather than
# trusting either.
$ahk = @(
    "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe"
    "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

$script = "$env:USERPROFILE\.config\ahk\nomouse.ahk"

if (-not $ahk) {
    Write-Warning "AutoHotkey v2 not found; the arrow layer and the herdr prefix stay dead"
} elseif (-not (Test-Path $script)) {
    Write-Warning "nomouse.ahk not deployed; nothing to start"
} else {
    # Start on login. Without this a reboot takes the arrow keys with it, on a
    # keyboard that has no other way to reach them.
    $startup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $lnk = Join-Path $startup "nomouse.lnk"
    if (-not (Test-Path $lnk)) {
        $s = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
        $s.TargetPath = $ahk
        $s.Arguments = "`"$script`""
        $s.WorkingDirectory = Split-Path -Parent $script
        $s.Description = "No-mouse 60% keyboard layer (dotfiles)"
        $s.Save()
        Ok "startup shortcut created"
    } else {
        Ok "startup shortcut already there"
    }

    if (Get-Process AutoHotkey* -ErrorAction SilentlyContinue) {
        Ok "already running"
    } else {
        Start-Process $ahk -ArgumentList "`"$script`""
        Start-Sleep -Seconds 2
        if (Get-Process AutoHotkey* -ErrorAction SilentlyContinue) {
            Ok "started"
        } else {
            Write-Warning "AutoHotkey did not stay running; check $env:TEMP\ahk_nomouse.log"
        }
    }
}

# ------------------------------------------------------------ linux half --
Say "handing over to the linux half"

# The repo may not be cloned yet, and bootstrap.sh lives inside it. Clone it
# first if it is missing, borrowing the Windows credential store so a private
# repo needs no second login.
$probe = wsl -d $distro -- bash -lc "test -d $repoLinux/.git && echo yes || echo no"
if (($probe -replace "`0", "").Trim() -ne "yes") {
    Ok "repo not cloned yet, cloning it"
    wsl -d $distro -- bash -lc @"
git config --global credential.helper '/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe'
mkdir -p ~/github
git clone $remote $repoLinux
"@
}

wsl -d $distro -- bash $repoLinux/bootstrap.sh

Say "done"
Write-Host @"
   Close every terminal and open a new one, so the login shell takes effect.

     ctrl+alt+g   open the whole environment
     ctrl+alt+r   put Claude back in the repo on the last conversation
     ctrl+alt+/   the key list
"@
