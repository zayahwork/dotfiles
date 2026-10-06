# terminal

herdr, WezTerm, Windows Terminal, and the Windows key layer underneath them.

## Contents

- [Ctrl+Alt+digit never arrives on Windows, because that chord is AltGr. Letters do.](#ctrlaltdigit-never-reaches-herdr-on-windows-ctrlaltletter-always-does)
- [herdr panes are not login shells on Linux, so `~/.local/bin` is empty in a new pane.](#herdr-panes-are-not-login-shells-on-linux-so-localbin-is-missing)
- [`panel_bg = "reset"`, or herdr paints an opaque block over the terminal background.](#herdr-paints-its-own-pane-background-over-terminal-transparency)
- [A full screen view cannot draw through an agent's pipe. Split the pane and run it there.](#a-full-screen-view-renders-into-an-agents-pipe-as-escape-codes-nobody-sees)
- [`ls` is eza, which prints nothing at all under a non-tty. Use `/bin/ls`.](#ls-is-aliased-to-eza-and-prints-nothing-at-all-under-a-non-tty)
- [Held back: `path` replaced `PATH` across 5 zsh subjects, literal `\n` raised 2 Python SyntaxErrors, double-quoted `rg` patterns executed 4 substitutions, and bare zsh globs stopped 4 commands before execution.](#held-back)

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

---

## Held back

### `path` replaced `PATH` and made 8 command names unavailable across 5 zsh subjects

**verified:** 2026-09-20, `zsh -fc 'original_path=$PATH; path=/tmp/example-file; print -r -- "PATH=$PATH"; whence -p perl || print perl=not-found; whence -p git || print git=not-found'` printed `PATH=/tmp/example-file`, `perl=not-found`, and `git=not-found`; 2026-10-04, a three-iteration `for path in ...` job-search loop printed `zsh: command not found: curl` and `head` on every iteration
**verified:** 2026-10-05, commands ran before `for path in "$HOME/.claude/CLAUDE.md" ...` in `/Users/zayah/github/dotfiles`, then `rg`, `gh`, and `head` each returned `zsh: command not found`; an isolated `zsh -fc` reproduction showed `path=( /tmp/b )`, `PATH=/tmp/b`, and `rg missing`
**verified:** 2026-10-05 at about 6:40 pm Pacific, `for path in ...` from `/Users/zayah/Documents/Codex/2026-09-29/job-applications` printed `zsh:4: command not found` for `gh`, `base64`, and `sed` on every iteration after assigning `path`
**verified:** 2026-10-05 at 7:07 pm Pacific, another `for path in ...` tooling loop printed `zsh: command not found: gh` and `sed` for every item immediately after assigning `path`
**where:** five zsh subjects covering an isolated reproduction, a remote-job endpoint loop, a dotfiles check, and two job-application tooling loops

Lowercase `path` is a special zsh array tied to uppercase `PATH`, so assigning a filename or endpoint to it replaced command lookup in all five observations.

**Why:** still held back at n=5 from five zsh subjects because no untouched control was measured; the five-subject count alone does not pass the causal bar.
**Fix:** never use `path` as a loop or scalar variable in zsh; use `repo_file`, `file_path`, `endpoint_path`, or another task-specific name. Add a reusable shell-command preflight that rejects assignments and loop variables named `path`, `status`, `HOME`, or `CODEX_HOME`; this prevention check remains UNCONFIRMED until built and exercised.

### `SyntaxError: unexpected character after line continuation character` from literal `\n` in `python3 -c` at n=2

**verified:** 2026-10-05, bundled Python invoked through zsh as `python3 -c ${JSON.stringify(code)}` exited 1 and printed the full escaped script beginning with literal `\nfrom pathlib...`, followed by exactly `SyntaxError: unexpected character after line continuation character`; a second workbook-inspection invocation with literal `\n` sequences returned the same exact SyntaxError before reading the workbook, while rewriting it as one list comprehension with no literal `\n` succeeded and printed `{"summary_tailored": 37, "summary_submitted": 35, "matches": []}`
**where:** two bundled-Python commands assembled for zsh `python3 -c`

The observed script began with backslash and `n` characters instead of a real newline, so Python parsed the backslash as a line continuation before reaching the unexpected `n`.

**Why:** REJECT at n=2 from two invocation subjects in one environment; there are not five observations from five different subjects.
**Fix:** use a real single-line expression for short `python3 -c` work, as confirmed by the list-comprehension output; for nontrivial logic, write a file in the writable work directory with `apply_patch`, then run the bundled Python executable on that file.

### Backticks inside double-quoted `rg` patterns executed 4 substitutions across 3 shell invocations

**verified:** 2026-10-03, a zsh command passed a backtick-wrapped `pdftotext` token inside a double-quoted `rg` pattern and printed exactly `zsh:2: command not found: pdftotext` before the search results
**verified:** 2026-10-05, a dotfiles-library lookup used a double-quoted `rg` pattern containing backticks around `AttributeError`, printed exactly `zsh:1: command not found: AttributeError`, and then returned the remaining search matches
**verified:** 2026-10-05, one dotfiles-library lookup invoked two double-quoted `rg` patterns containing backticks around `path`; zsh printed exactly `zsh:1: command not found: path` twice before returning the remaining search matches
**where:** four substitutions across three dotfiles-library verification shell invocations in macOS zsh

The shell executed the backtick contents as command substitution before `rg` received the pattern.

**Why:** REJECT after four substitutions across three shell-invocation subjects; there are not five observations from five different subjects.
**Fix:** single-quote search patterns that contain Markdown backticks, or escape each backtick before passing the pattern through zsh; the third-recurrence rule now requires a reusable preflight check, which remains UNCONFIRMED until built and exercised.

### zsh `no matches found` stopped 4 bare glob and query arguments before execution

**verified:** 2026-10-03, an `rg` command with bare unmatched `*.md *.json` arguments returned exactly `zsh:1: no matches found: *.md` before `rg` executed
**verified:** 2026-10-05, unquoted `gh api repos/Gsync/jobsync/commits?per_page=5` failed before `gh` ran because zsh treated `?` as a glob and printed `no matches found`
**verified:** 2026-10-05, unquoted `gh api repos/LingyiChen-AI/JadeAI/issues?state=open&per_page=5` failed before `gh` ran with exactly `zsh: no matches found:` followed by the endpoint argument
**verified:** 2026-10-05, an `rg` command with bare unmatched `applications*` failed before `rg` ran with exactly `zsh: no matches found: applications*`
**where:** four zsh commands in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

All four failures occurred while zsh parsed unquoted glob or query metacharacters, before the named tool could handle the argument.

**Why:** REJECT at n=4 from four shell-command subjects; there are not five observations from five different subjects.
**Fix:** quote every `gh api` endpoint containing `?` or `&`, such as `gh api 'repos/OWNER/REPO/issues?state=open&per_page=5'`, pass file filters through quoted `rg --glob '*.md' --glob '*.json'` arguments, and run `rg --files` before passing uncertain path targets; the corrected JadeAI request and required third-recurrence prevention check remain UNCONFIRMED.
