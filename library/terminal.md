# terminal

herdr, WezTerm, Windows Terminal, and the Windows key layer underneath them.

## Contents

- Ctrl+Alt+digit never arrives on Windows, because that chord is AltGr. Letters do.
- herdr panes are not login shells on Linux, so `~/.local/bin` is empty in a new pane.
- `panel_bg = "reset"`, or herdr paints an opaque block over the terminal background.
- A full screen view cannot draw through an agent's pipe. Split the pane and run it there.
- `ls` is eza, which prints nothing at all under a non-tty. Use `/bin/ls`.

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

---

## A full screen view renders into an agent's pipe as escape codes nobody sees

**verified:** 2026-09-01, `goodnight` run through an agent wrote 70k of escape codes to a
capture file and showed nothing; the same command in a pane drew normally
**where:** any TUI an agent starts, gnhf being the one that caught us

A program that takes the alternate screen needs a terminal to take. Started by an agent
its stdout is a pipe, so it draws happily into a file and the person watching sees an
empty screen, or worse, waits.

**Why:** the agent's own pane is already owned by the agent, so there is nothing to hand
over even when a terminal exists somewhere.

**Fix:** split the pane the agent was called from and run there. Same terminal, beside
the conversation, and the person can watch it:

```sh
current=$(herdr pane current | jq -r '.result.pane.pane_id')
split=$(herdr pane split "$current" --direction down | jq -r '.result.pane.pane_id')
herdr pane run "$split" <command>
```

`home/bin/goodnight` does exactly that when `[ ! -t 1 ]`, and takes `--here` to override
it. Any tool we write that draws a full screen needs the same check.

---

## ls is aliased to eza and prints nothing at all under a non-tty

**verified:** 2026-09-01, `zsh -ic 'ls' </dev/null` returns 0 lines in a directory where
`/bin/ls` returns 10
**where:** every agent shell on this machine

Not fewer lines, not unformatted lines. Nothing, and exit 0. An agent listing a
directory sees what looks exactly like an empty one and reasons from it.

**Why:** `home.nix` aliases `ls` to `eza`, and eza suppresses output when stdout is not a
terminal.

**Fix:** `/bin/ls` in anything an agent runs, or `find` when you want it recursive.
Never trust an empty `ls` from a script.
