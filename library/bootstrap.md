# bootstrap

Standing this repo up on a machine that has never run it. Everything here was hit on
2026-09-02, taking a clean WSL Ubuntu from nothing to a working environment.

The shape of the problem: `home-manager switch` is one of two halves. It owns Linux and
nothing else. The Windows half is five apps and a PowerShell script, and nothing in the
repo tells you that until it does not work.

## Contents

- [`home.nix` hardcodes the Linux username. A machine whose user is not that name cannot switch at all.](#homenix-hardcodes-the-linux-username-so-the-wrong-user-cannot-switch-at-all)
- [`wsl.exe -d Ubuntu -- zsh` exits 127. WezTerm opens and shuts instantly, with no error on screen.](#wslexe--d-ubuntu----zsh-exits-127-and-the-terminal-window-just-vanishes)
- [`sudo chsh` prints "invalid shell" as a warning and applies the shell anyway.](#sudo-chsh-prints-invalid-shell-and-changes-the-shell-anyway)
- [home-manager deploys nothing on the Windows side. `windows/apply.ps1` is a second step nobody is told to run.](#home-manager-deploys-nothing-on-the-windows-side)
- [The default WSL distro is `docker-desktop`, which has no shell at all. Always pass `-d Ubuntu`.](#the-default-wsl-distro-here-is-docker-desktop-which-has-no-shell)
- [Nothing installs the Nerd Font, so WezTerm silently falls back to Consolas and glyphs render as boxes.](#nothing-installs-the-nerd-font-and-wezterm-falls-back-without-complaint)
- [winget puts AutoHotkey v2 in `C:\Program Files\AutoHotkey\v2\`, not the path `apply.ps1` prints.](#winget-puts-autohotkey-v2-somewhere-other-than-the-path-applyps1-prints)
- [`nomouse.ahk` does not start itself on login. The whole key layer is gone after a reboot.](#nomouseahk-does-not-start-on-login-so-the-key-layer-dies-at-every-reboot)
- [`ctrl+alt+g` is bound twice, in AutoHotkey and in herdr. UNCONFIRMED which wins.](#ctrlaltg-is-bound-twice-and-only-one-of-them-can-win)
- [`cr` is an alias for cursor-agent, which nothing installs and which is not in nixpkgs.](#the-cr-alias-points-at-cursor-agent-which-nothing-in-this-repo-installs)

---

## home.nix hardcodes the Linux username, so the wrong user cannot switch at all

**verified:** 2026-09-02, `getent passwd stuck` returned `/home/stuck` against
`home.username = "pc"` in `home.nix`
**where:** `home.nix` lines 4-5, `flake.nix` `homeConfigurations."pc"`, seven absolute
`/home/pc/.local/bin/...` paths in the herdr block, `home/bin/apply`, `README.md`

home-manager refuses to activate when `home.username` disagrees with the user running
it, so on this machine no `apply` could ever have succeeded. The name appeared in five
files, and the seven herdr command paths are the ones that fail silently rather than
loudly: the switch succeeds and the keybinds point at a home directory that does not
exist.

**Fix:** renamed to `stuck` in all five. `library/` keeps the old name on purpose, since
those entries record what happened. The real fix is to stop hardcoding it, which this
repo has not done yet.

### Held back

**home.homeDirectory is /Users/$user on Darwin. /home/$user would be a directory that does not exist.**
n=1, 2026-09-08, `home.nix` read on a Linux x86_64 VM. No Darwin switch. Rejected: n is
not five, never observed, no control, and the same edit also parameterized `username`.

---

## wsl.exe -d Ubuntu -- zsh exits 127, and the terminal window just vanishes

**verified:** 2026-09-02, `wsl.exe -d Ubuntu --cd ~/github/dotfiles -- zsh -lic "echo hi"`
printed `zsh:1: command not found: zsh`, exit 127
**where:** `windows/wezterm.lua`, `config.default_prog`

This is the same trap the file already documents for `herdr`, one level up, and the
existing comment does not cover it. The shell `wsl.exe` runs a command in has not
sourced `hm-session-vars.sh`, so `~/.nix-profile/bin` is not on PATH, and `zsh` is no
more findable than `herdr` was. WezTerm runs `default_prog`, it exits 127 immediately,
and the window closes before anything is drawn. There is no error anywhere: no WezTerm
log directory is created, and the AutoHotkey log records a successful launch.

**Fix:** spell zsh out by path, `~/.nix-profile/bin/zsh -lic "exec herdr"`. Naming one
of the two by path is enough, because that zsh is a login shell and sets the PATH the
rest of the line needs. The general rule: anything handed to `wsl.exe --` must be
addressable without Nix's PATH.

---

## sudo chsh prints "invalid shell" and changes the shell anyway

**verified:** 2026-09-02, `sudo chsh -s ~/.nix-profile/bin/zsh stuck` printed
`chsh: Warning: /home/stuck/.nix-profile/bin/zsh is an invalid shell`, and
`getent passwd stuck` then returned that exact path
**where:** first login after a switch, on any new machine

`/etc/shells` lists only the distro's own shells, and a Nix-built zsh is never in it.
The message is a warning, not an error, and root applies the change regardless. Read the
word "Warning" before undoing anything.

**Fix:** nothing to fix, but verify with `getent passwd <user> | cut -d: -f7` rather
than trusting the message. The shell takes effect on the next session, not the one that
ran the command.

---

## home-manager deploys nothing on the Windows side

**verified:** 2026-09-02, `windows/` is on `development` and referenced nowhere in
`home.nix`; `C:\Users\Stuck\.wezterm.lua` and `~\.config\ahk\nomouse.ahk` were both
absent after a successful switch
**where:** `windows/apply.ps1`, `windows/wezterm.lua`, `windows/nomouse.ahk`,
`windows/windows-terminal-settings.json`

A switch that reports success leaves the terminal unstyled, the launch hotkey dead and
the entire no-mouse key layer missing, with nothing on screen saying so. This is the
single biggest gap between "the repo applied" and "the machine works".

**Fix:** `powershell -ExecutionPolicy Bypass -File windows\apply.ps1`, which copies all
three and keeps a `.bak` of whatever was there. It is a separate step, and the README
does not mention it.

---

## The default WSL distro here is docker-desktop, which has no shell

**verified:** 2026-09-02, `wsl.exe -e bash -lc ...` returned
`execvpe(bash) failed: No such file or directory`; `wsl -l -v` shows `* docker-desktop`
**where:** every `wsl` invocation, and anything on Windows that shells into WSL

Docker Desktop registers its own distro and takes the default marker. A `wsl` command
with no `-d` lands there and fails in a way that reads like a broken Ubuntu.

**Fix:** always `-d Ubuntu`. `windows/wezterm.lua` already does this correctly.

---

## Nothing installs the Nerd Font, and WezTerm falls back without complaint

**verified:** 2026-09-02, the Windows font list matched no `JetBrains|Nerd|Caskaydia`
before `winget install DEVCOM.JetBrainsMonoNerdFont` (3.3.0)
**where:** `windows/wezterm.lua`, `config.font` fallback list

The list ends in Consolas, so the terminal renders, looks nearly right, and every
powerline separator and status glyph comes out as a box. Nothing errors.

**Fix:** `winget install DEVCOM.JetBrainsMonoNerdFont`. It registers as
`JetBrainsMono Nerd Font`, which is the second entry in the fallback list, so no config
change is needed once it is present.

---

## winget puts AutoHotkey v2 somewhere other than the path apply.ps1 prints

**verified:** 2026-09-02, `winget install AutoHotkey.AutoHotkey` (2.0.27) installed to
`C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe`
**where:** the restart hint printed at the end of `windows/apply.ps1`

The script tells you to start it from
`%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe`, which does not exist after a
winget install. Copying that line verbatim fails. The path in `nomouse.ahk` itself, for
`ctrl+alt+g` launching WezTerm, is correct.

**Fix:** `C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe`. The hint in `apply.ps1` is
still wrong and should be corrected.

---

## nomouse.ahk does not start on login, so the key layer dies at every reboot

**verified:** 2026-09-02, no entry in
`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup` after `apply.ps1`
**where:** `windows/apply.ps1`

`apply.ps1` copies the script and tells you to start it by hand. Nothing makes that
survive a restart, and what is lost is the arrow keys, the mouse layer and the herdr
prefix, on a keyboard that has no other way to reach them.

**Fix:** a `nomouse.lnk` shortcut in the Startup folder pointing at
`AutoHotkey64.exe` with the script as its argument. Created by hand on 2026-09-02;
`apply.ps1` should do it.

---

## ctrl+alt+g is bound twice, and only one of them can win

**verified:** 2026-09-02, `^!g` in `windows/nomouse.ahk` raises WezTerm;
`key = "ctrl+alt+g"` in `home.nix` runs `commit-url --open`
**where:** `windows/nomouse.ahk`, the `[[keys.command]]` block in `home.nix`

AutoHotkey registers its hotkeys with the OS, so it should intercept the chord before
the terminal sees it, which would make `commit-url --open` unreachable while the layer
is running. UNCONFIRMED: not tested by pressing it. `ctrl+alt+a` in the same block runs
`C:\Corp-builder\agents.ps1`, which does not exist on this machine.

**Fix:** none applied. One of the two needs a different chord.

---

## The cr alias points at cursor-agent, which nothing in this repo installs

**verified:** 2026-09-02, `cr` in a fresh pane printed
`zsh: command not found: cursor-agent`; `nix eval nixpkgs#cursor-agent` errored
with no such attribute
**where:** `programs.zsh.shellAliases` in `home.nix`, and the `[terminal]`
comment in the herdr block that says cursor-agent lives in `~/.local/bin`

It is not in `home.packages`, and it is not in nixpkgs, so no switch has ever
put it on a machine. The alias worked only on the box where it had been
installed by hand, which is the thing this repo exists to stop. `~/.local/bin`
holds one home-manager symlink per file rather than owning the directory, so an
installer can drop a binary in beside them.

**Fix:** `curl https://cursor.com/install -fsS | bash`. bootstrap.sh does this
now, fetching the script to a file and running it from there rather than piping
the network into a shell. Installed 2026.08.31-4057e58 on 2026-09-02 and `cr`
resolves to `~/.local/bin/cursor-agent`.

The installer is 5668 bytes, pulls a tarball from downloads.cursor.com, unpacks
it under `~/.local/share/cursor-agent/versions/`, and symlinks `cursor-agent`
and `agent` into `~/.local/bin`. No sudo and nothing outside `$HOME`, so it
cannot collide with the home-manager symlinks already in that directory.
