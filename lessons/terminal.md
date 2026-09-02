# terminal

herdr, WezTerm, Windows Terminal, and the Windows key layer underneath them.

---

## Ctrl+Alt+digit never reaches herdr on Windows

**hit:** 2026-09-01
**where:** `home.nix`, the `[keys]` block of the herdr config

`switch_tab = "ctrl+alt+1..9"` did nothing. The letter chords next to it in the same
table (`ctrl+alt+h`, `ctrl+alt+v`) fired every time, so the config was being read and
the binding was not broken.

**Why:** on Windows, Ctrl+Alt is AltGr. The digit row gets consumed by the keyboard
layer before the terminal sees it. Letters survive it, digits do not.
**Fix:** tab numbers moved behind the prefix, `switch_tab = "prefix+1..9"`. Do not spend
time on a Ctrl+Alt+digit binding here again.

---

## herdr panes could not find anything in ~/.local/bin

**hit:** 2026-09-01
**where:** new herdr panes, `cursor-agent` and the `corp-*` scripts

`cursor-agent` and the corp scripts ran fine in a normal shell and were not found in a
fresh herdr pane.

**Why:** home-manager exports PATH from `hm-session-vars.sh`, which only login shells
source. herdr's `shell_mode = "auto"` only makes panes login shells on macOS, so on
Linux every pane skipped it and never saw `~/.local/bin`.
**Fix:** both halves, in `home.nix`. `shell_mode = "login"` in the herdr config, and
`export PATH="$HOME/.local/bin:$PATH"` in `programs.zsh.initContent` so it holds for
interactive non-login shells too.

---

## herdr painted an opaque block over the terminal background

**hit:** 2026-09-01
**where:** `home.nix`, `[theme.custom]`

Terminal transparency worked on the sidebar and not in the pane area, so the sidebar
looked like frosted glass and the panes looked like a solid black rectangle.

**Why:** herdr fills the pane background with its own theme colour rather than leaving
it alone.
**Fix:** `panel_bg = "reset"`, which lets the terminal's own background through.
