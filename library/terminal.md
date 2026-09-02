# terminal

herdr, WezTerm, Windows Terminal, and the Windows key layer underneath them.

## Contents

- Ctrl+Alt+digit never arrives on Windows, because that chord is AltGr. Letters do.
- herdr panes are not login shells on Linux, so `~/.local/bin` is empty in a new pane.
- `panel_bg = "reset"`, or herdr paints an opaque block over the terminal background.

---

## Ctrl+Alt+digit never reaches herdr on Windows, Ctrl+Alt+letter always does

**verified:** 2026-09-01, commits `1fcb7fa` and `b81deb3`, fix live in `home.nix`
**where:** the `[keys]` block of the herdr config

`switch_tab = "ctrl+alt+1..9"` did nothing, while the letter chords in the same table
(`ctrl+alt+h`, `ctrl+alt+v`) fired every time, so the config was read and the binding
was not broken.

**Why:** on Windows, Ctrl+Alt is AltGr, and the digit row is consumed by the keyboard
layer before the terminal sees it. Letters survive it, digits do not.
**Fix:** `switch_tab = "prefix+1..9"`. Do not spend time on a Ctrl+Alt+digit binding
here again, on any tool.

---

## herdr panes are not login shells on Linux, so ~/.local/bin is missing

**verified:** 2026-09-01, `shell_mode = "login"` and the zsh `initContent` in `home.nix`
**where:** new herdr panes, `cursor-agent` and the `corp-*` scripts

Both ran fine in a normal shell and were not found in a fresh pane.

**Why:** home-manager exports PATH from `hm-session-vars.sh`, which only login shells
source. herdr's `shell_mode = "auto"` only makes panes login shells on macOS.
**Fix:** both halves. `shell_mode = "login"` in the herdr config, and
`export PATH="$HOME/.local/bin:$PATH"` in `programs.zsh.initContent`, so it holds for
interactive non-login shells too.

---

## herdr paints its own pane background over terminal transparency

**verified:** 2026-09-01, `[theme.custom]` in `home.nix`
**where:** herdr theme config

Transparency worked on the sidebar and not in the pane area, so the sidebar looked like
frosted glass and the panes looked like a solid black rectangle.

**Fix:** `panel_bg = "reset"`, which lets the terminal's own background through.
