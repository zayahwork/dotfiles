# terminal

herdr, WezTerm, Windows Terminal, and the Windows key layer underneath them.

## Contents

- [Ctrl+Alt+digit never arrives on Windows, because that chord is AltGr. Letters do.](#ctrlaltdigit-never-reaches-herdr-on-windows-ctrlaltletter-always-does)
- [herdr panes are not login shells on Linux, so `~/.local/bin` is empty in a new pane.](#herdr-panes-are-not-login-shells-on-linux-so-localbin-is-missing)
- [`panel_bg = "reset"`, or herdr paints an opaque block over the terminal background.](#herdr-paints-its-own-pane-background-over-terminal-transparency)
- [A full screen view cannot draw through an agent's pipe. Split the pane and run it there.](#a-full-screen-view-renders-into-an-agents-pipe-as-escape-codes-nobody-sees)
- [`ls` is eza, which prints nothing at all under a non-tty. Use `/bin/ls`.](#ls-is-aliased-to-eza-and-prints-nothing-at-all-under-a-non-tty)
- [`rg -h` is help in ripgrep 15.2.0; use `--no-filename`.](#rg--h-is-help-in-ripgrep-1520-use---no-filename)
- [`rg` parsed a pattern beginning with `--target` as a flag; insert `--` before the pattern.](#rg-parsed-a-pattern-beginning-with---target-as-a-flag-insert---before-the-pattern)
- [Held back: `path` replaced `PATH` across 8 zsh subjects, `status` was read-only in 4 commands, one quoted spec stayed one argument, literal `\n` raised 2 Python SyntaxErrors, double-quoted backticks caused 8 failures, `rg` options after `--` became paths twice, bare zsh globs stopped 44 commands, and the exec safety gate rejected 3 `rm` removals.](#held-back)
- [macOS `date %:z` exited 0 with literal `:z` suffixes at n=3.](#macos-date-z-exited-0-with-literal-z-suffixes-at-n3)
- [macOS date emitted literal `.3NZ` on 3 millisecond timestamp attempts; Node ISO parsed.](#macos-date-emitted-literal-3nz-on-3-millisecond-timestamp-attempts-node-iso-parsed)
- [macOS date returned `Failed conversion` twice for one valid fractional-second ISO timestamp.](#macos-date-returned-failed-conversion-twice-for-one-valid-fractional-second-iso-timestamp)

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

## `rg -h` is help in ripgrep 15.2.0; use `--no-filename`

**verified:** 2026-10-10, GovernmentJobs aggregation used `rg -h` expecting grep-style filename suppression and counted 124 help lines for every source; replacing it with `rg --no-filename` produced 184 unique URLs across Seattle 65, King County 100, Bellevue 9, and Snohomish County 10
**verified:** 2026-10-10, a fresh `rg -h 'fatal' library/testing.md` invocation printed 135 help lines instead of matches; `rg --version` reported 15.2.0, and its help identifies `-h, --help` plus `-I, --no-filename`
**where:** ripgrep source aggregation and one isolated flag check on this macOS machine

The short flag collision is direct installed-command behavior, not a listing-count result.

**Why:** ripgrep 15.2.0's own help and both observed calls agree that `-h` invokes help, while `--no-filename` suppresses source names.
**Fix:** use `rg --no-filename` or `rg -I` when combining matches from multiple files, and validate the aggregate against expected URL-shaped output before counting it.

---

## `rg` parsed a pattern beginning with `--target` as a flag; insert `--` before the pattern

**verified:** 2026-10-11, ripgrep 15.2.0 ran `rg -n "--target|daily_target|max_prepared|argparse|run_parser" pipeline.py`, exited 2, and printed exactly `rg: unrecognized flag --target|daily_target|max_prepared|argparse|run_parser`; retrying with `rg -n -- "--target|daily_target|max_prepared|argparse|run_parser" pipeline.py` exited 0 and returned matches including `run_parser.add_argument("--target"...)`
**where:** `pipeline.py` in `/Users/zayah/Documents/Codex/life/01 💼 Jobs/03 🛠️ Tools/⚙️ Job Pipeline`

The failed and successful calls differed only by ripgrep's explicit end-of-options delimiter.

**Why:** ripgrep treated the leading `--target` portion of the positional pattern as a command option before it attempted the search.
**Fix:** put `--` after ripgrep options whenever the search pattern can begin with `-`, then verify nonempty matches rather than trusting the exit code alone.

---

## Held back

### `rm -f style commands are not permitted. Use a safer approach` at n=3

**verified:** 2026-10-04, `exec_command` rejected a multiline DOCX render command containing `rm -rf work/welo-cv-render` with exactly `rm -f style commands are not permitted. Use a safer approach`
**verified:** 2026-10-06, the execution layer rejected explicit single-file command `rm -f /Users/zayah/Documents/Codex/2026-09-29/job-applications/outputs/job-application-tracker.xlsx.inspect.ndjson` with exactly `rm -f style commands are not permitted. Use a safer approach`; the target was a generated inspection sidecar
**verified:** 2026-10-06, a combined document build and render command containing `rm -rf job-pipeline/work/heartbeat-2026-10-06-0950/qa-office-depot` was rejected before execution with exactly `rm -f style commands are not permitted. Use a safer approach`; `shell-preflight` then rejected the same rm command, accepted a fresh-directory command, and its later expanded suite printed `shell-preflight: 33 fixtures passed`
**where:** three removal commands in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`, covering two recursive render or QA directories and one explicit generated file

All three commands were rejected before removal, but the evidence does not establish the execution layer's complete deletion policy.

**Why:** still held back at n=3 from three command subjects in one execution layer; there are not five observations from five different subjects.
**Fix:** use a fresh never-before-used output directory or `mktemp -d` instead of deleting or reusing a render directory, and leave generated sidecars in place rather than bypassing the command gate. Run `shell-preflight '<planned command>'` first; its verified rm check rejects direct and combined rm commands before execution.

### `path` replaced `PATH` and made 8 command names unavailable across 8 zsh subjects

**verified:** 2026-09-20, `zsh -fc 'original_path=$PATH; path=/tmp/example-file; print -r -- "PATH=$PATH"; whence -p perl || print perl=not-found; whence -p git || print git=not-found'` printed `PATH=/tmp/example-file`, `perl=not-found`, and `git=not-found`; 2026-10-04, a three-iteration `for path in ...` job-search loop printed `zsh: command not found: curl` and `head` on every iteration
**verified:** 2026-10-05, commands ran before `for path in "$HOME/.claude/CLAUDE.md" ...` in `/Users/zayah/github/dotfiles`, then `rg`, `gh`, and `head` each returned `zsh: command not found`; an isolated `zsh -fc` reproduction showed `path=( /tmp/b )`, `PATH=/tmp/b`, and `rg missing`
**verified:** 2026-10-05 at about 6:40 pm Pacific, `for path in ...` from `/Users/zayah/Documents/Codex/2026-09-29/job-applications` printed `zsh:4: command not found` for `gh`, `base64`, and `sed` on every iteration after assigning `path`
**verified:** 2026-10-05 at 7:07 pm Pacific, another `for path in ...` tooling loop printed `zsh: command not found: gh` and `sed` for every item immediately after assigning `path`
**verified:** 2026-10-05, `for path in Argus/store.py ...; do ...; done` in the job-applications heartbeat printed `zsh:1: command not found: gh`, `base64`, and `sed` for every item after the first `path` assignment, exited 127, and produced 570 output bytes
**verified:** 2026-10-06, another `for path in ...; do ...; gh ... | sed ...; done` research loop returned `command not found: gh` and `command not found: sed` on every iteration after assigning the special lowercase `path` variable
**verified:** 2026-10-06, `for path in ...; do gh ... | base64 ... | sed ...; done` in `/Users/zayah/Documents/Codex/2026-09-29/job-applications` printed exactly `command not found: gh`, `command not found: base64`, and `command not found: sed` for every iteration; the `repo_file` retry restored all three commands, and a current `whence -p` control returned `/opt/homebrew/bin/gh`, `/usr/bin/base64`, and `/usr/bin/sed`
**where:** eight zsh subjects covering an isolated reproduction, a remote-job endpoint loop, a dotfiles check, and five job-application tooling loops

Lowercase `path` is a special zsh array tied to uppercase `PATH`, so assigning a filename or endpoint to it replaced command lookup in all eight observations.

**Why:** still held back at n=8 from eight zsh subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** never use `path` as a loop or scalar variable in zsh; use `repo_file`, `file_path`, `endpoint_path`, or another task-specific name, then rerun and check output. `shell-preflight` now rejects assignments and loop variables named `path`, `status`, `HOME`, or `CODEX_HOME`, and its self-test prints `shell-preflight: 44 fixtures passed`.

### `status` assignment returned `read-only variable: status` in 4 zsh commands

**verified:** 2026-09-30, assigning a curl result to `status` returned exactly `zsh:1: read-only variable: status`, while renaming the variable to `http_code` worked
**verified:** 2026-10-06, `for ...; do status=$(curl ...); ...; done` in `/Users/zayah/Documents/Codex/2026-09-29/job-applications` failed immediately with exactly `zsh: read-only variable: status`; a current isolated assignment reproduced that exact error, `${(t)status}` printed `integer-readonly-special`, and `http_code=200` printed `200`
**verified:** 2026-11-01, a dotfiles verification command assigned `status=$?` and returned exactly `zsh:7: read-only variable: status`; the corrected variable `preflight_exit=$?` printed the expected code, while `shell-preflight` rejected `status=$?` and its expanded self-test printed `shell-preflight: 44 fixtures passed`
**where:** four assignments in one macOS zsh environment

The three workflow failures and isolated reproduction establish that lowercase `status` is read-only in this zsh environment.

**Why:** REJECT at n=4 from one shell-parameter subject and environment; there are not five observations from five different subjects.
**Fix:** use `http_code`, `preflight_exit`, or another task-specific variable name instead of `status`; run `shell-preflight '<planned command>'` first because it now rejects assignments and loop variables named `status`.

### Quoted zsh spec stayed 1 argument and produced `sed: invalid command code ,` at n=1

**verified:** 2026-10-10, `for spec in "legal-admin 130 300"; do set -- $spec; ...; done` produced `count=1`, kept the complete string in `$1`, left `$2` and `$3` empty, and `sed -n "${2},${3}p"` returned exactly `sed: 1: ",p` followed by `invalid command code ,`
**verified:** 2026-10-10, replacing the compound string with `spec=(legal-admin 130 300); set -- "${spec[@]}"` produced exactly `count=3 one=legal-admin two=130 three=300`, and the corrected `sed` invocation exited 0
**where:** one macOS zsh GovernmentJobs source-spec loop and one isolated reproduction

The quoted loop item remained one scalar, and zsh did not perform implicit Bourne-style word splitting when it was expanded for `set`.

**Why:** REJECT at n=1 workflow subject plus one isolated reproduction; there are not five observations from five different subjects.
**Fix:** use a proper zsh array and expand it as `"${spec[@]}"`, or use explicit commands instead of encoding multiple fields in one quoted string.

### `SyntaxError: unexpected character after line continuation character` from literal `\n` in `python3 -c` at n=2

**verified:** 2026-10-05, bundled Python invoked through zsh as `python3 -c ${JSON.stringify(code)}` exited 1 and printed the full escaped script beginning with literal `\nfrom pathlib...`, followed by exactly `SyntaxError: unexpected character after line continuation character`; a second workbook-inspection invocation with literal `\n` sequences returned the same exact SyntaxError before reading the workbook, while rewriting it as one list comprehension with no literal `\n` succeeded and printed `{"summary_tailored": 37, "summary_submitted": 35, "matches": []}`
**where:** two bundled-Python commands assembled for zsh `python3 -c`

The observed script began with backslash and `n` characters instead of a real newline, so Python parsed the backslash as a line continuation before reaching the unexpected `n`.

**Why:** REJECT at n=2 from two invocation subjects in one environment; there are not five observations from five different subjects.
**Fix:** use a real single-line expression for short `python3 -c` work, as confirmed by the list-comprehension output; for nontrivial logic, write a file in the writable work directory with `apply_patch`, then run the bundled Python executable on that file.

### Backticks inside double quotes caused 7 substitutions and 1 parse failure across 7 shell invocations

**verified:** 2026-10-03, a zsh command passed a backtick-wrapped `pdftotext` token inside a double-quoted `rg` pattern and printed exactly `zsh:2: command not found: pdftotext` before the search results
**verified:** 2026-10-05, a dotfiles-library lookup used a double-quoted `rg` pattern containing backticks around `AttributeError`, printed exactly `zsh:1: command not found: AttributeError`, and then returned the remaining search matches
**verified:** 2026-10-05, one dotfiles-library lookup invoked two double-quoted `rg` patterns containing backticks around `path`; zsh printed exactly `zsh:1: command not found: path` twice before returning the remaining search matches
**verified:** 2026-10-06, a dotfiles-library staged-file check used a double-quoted `rg` pattern containing backticks around `docx`, printed exactly `zsh:6: command not found: docx`, and the corrected single-quoted pattern returned the intended heading and evidence lines
**verified:** 2026-10-10, a double-quoted `git commit -m` body contained backticks around `legal-admin 130 300`; zsh printed exactly `zsh:4: command not found: legal-admin`, and the resulting commit body omitted the backtick-wrapped text
**verified:** 2026-10-11, a dotfiles-library verification command included backticks around `--` inside a double-quoted `rg` pattern; zsh printed exactly `zsh:2: command not found: --` before `rg` returned the remaining matches
**verified:** 2026-10-12, a dotfiles-library verification command put one Markdown backtick inside a double-quoted `rg` pattern and zsh returned exactly `zsh:1: unmatched "` before the lookup; the corrected single-quoted pattern returned five evidence lines and the intended commit succeeded
**where:** seven substitutions and one parse failure across seven dotfiles-library verification and commit shell invocations in macOS zsh

The shell executed complete exposed backtick pairs as command substitutions and rejected the unpaired backtick during parsing before the named command received its argument.

**Why:** still held back after eight failures across seven shell-invocation subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** single-quote arguments that contain Markdown backticks, or escape each backtick before passing the text through zsh. Run `shell-preflight '<planned command>'` first; it rejects exposed backticks inside unquoted or double-quoted arguments, accepts single-quoted backticks, and its 33-fixture suite passes.

### `rg` options after `--` were treated as file paths on 3 invocations; shell-preflight now rejects the order

**verified:** 2026-10-12, a repeated lookup placed search paths before later `--glob` filters and ripgrep treated the filters and patterns as file paths; an isolated reproduction with `rg -n -- 'NO_SUCH_SENTINEL_PATTERN' library --glob '*.json' --glob '*.md' --glob '*.txt'` printed `rg: --glob: No such file or directory` three times plus one missing-file error for each glob, while `rg -n --glob '*.json' --glob '*.md' --glob '*.txt' -- 'Backticks inside double quotes' library` returned one match
**verified:** 2026-10-19, `rg -n -- 'duplicateIndex|targetRow|A2:J200' <path> -g '*.mjs' -g '*.js' -g '*.json' -g '*.md'` printed `rg: -g: No such file or directory` four times plus one missing-file error for each pattern because all four filters followed `--`; moving the filters before `--` returned the intended source matches
**where:** three ripgrep lookup invocations in macOS zsh, including one isolated dotfiles-library reproduction with ripgrep 15.2.0

The isolated output shows that arguments after the `--` option terminator are positional paths even when they spell valid ripgrep options; the earlier repeated command's complete argv is UNCONFIRMED.

**Why:** still REJECT at n=3 from one command-order subject and environment; there are not five observations from five different subjects. The third recurrence triggered a reusable command check instead of another note alone.
**Fix:** put every filter before the option terminator, then the pattern and paths: `rg -n --glob '*.json' --glob '*.md' --glob '*.txt' -- 'PATTERN' path...`. `home/bin/shell-preflight` now rejects `-g`, `--glob`, or `--glob=...` after `--`; require nonempty expected matches before trusting the search.

### zsh `no matches found` stopped 44 bare glob and query arguments before execution

**verified:** 2026-10-03, an `rg` command with bare unmatched `*.md *.json` arguments returned exactly `zsh:1: no matches found: *.md` before `rg` executed
**verified:** 2026-10-05, unquoted `gh api repos/Gsync/jobsync/commits?per_page=5` failed before `gh` ran because zsh treated `?` as a glob and printed `no matches found`
**verified:** 2026-10-05, unquoted `gh api repos/LingyiChen-AI/JadeAI/issues?state=open&per_page=5` failed before `gh` ran with exactly `zsh: no matches found:` followed by the endpoint argument
**verified:** 2026-10-05, an `rg` command with bare unmatched `applications*` failed before `rg` ran with exactly `zsh: no matches found: applications*`
**verified:** 2026-10-05 at 7:06 pm Pacific, unquoted `gh api repos/TusharVashishth/localcv/git/trees/main?recursive=1` failed before `gh` ran with exactly `zsh: no matches found`
**verified:** 2026-10-05, after preceding commands printed valid ResumeForge metadata and README content, unquoted `gh api repos/magicapple123/ResumeForge/git/trees/main?recursive=1 --jq '.tree[].path'` failed before `gh` ran with exactly `zsh:1: no matches found: repos/magicapple123/ResumeForge/git/trees/main?recursive=1`
**verified:** 2026-10-05, unquoted `gh api repos/career-ops-hq/career-ops/git/trees/main?recursive=1` failed before `gh` ran with exactly `zsh: no matches found:` followed by the endpoint
**verified:** 2026-10-05 at 9:17 pm Pacific, unquoted `gh api repos/AloysJehwin/job-app/git/trees/HEAD?recursive=1` failed before `gh` ran with exactly `zsh:1: no matches found: repos/AloysJehwin/job-app/git/trees/HEAD?recursive=1`
**verified:** 2026-10-05 at about 10:16 pm Pacific, unquoted `gh api repos/NullSpace-BitCradle/ats-resume-agent/commits?per_page=5` failed before `gh` ran with `zsh: no matches found`
**verified:** 2026-10-05, unquoted `gh api repos/.../commits?per_page=5` and `gh api repos/.../issues?state=all\&per_page=20` each returned only a zsh `no matches found` error before `gh` ran, while simultaneous `gh repo view` and README calls succeeded
**verified:** 2026-10-05, unquoted `gh api` endpoints for `zoepan0109-coder/job-application-tracker-extension` ending in `issues?state=all\&per_page=20`, `commits?per_page=5`, and `git/trees/main?recursive=1` each returned `zsh: no matches found` before `gh` ran; the first compound command exited 1
**verified:** 2026-10-06, unquoted `gh api repos/.../commits?per_page=10` and `gh api repos/.../git/trees/main?recursive=1` each returned exactly `zsh:1: no matches found` before `gh` ran
**verified:** 2026-10-06 at 12:38 am Pacific, after metadata verified `Oscar6/app-tracker` default branch `main`, unquoted tree and commits endpoints ending in `main?recursive=1` and `commits?per_page=10` each returned `zsh: no matches found`
**verified:** 2026-10-06, `rg -n "26114030|P1-6894856|26100713|Marriott|Guest Service Support Expert|Guest Experience Expert" job-pipeline job-applications.* . --glob '!job-pipeline/state/source-log.json' --glob '!**/.git/**'` returned exactly `zsh:1: no matches found: job-applications.*` before `rg` ran
**verified:** 2026-10-06, unquoted `gh api repos/OWNER/REPO/git/trees/HEAD?recursive=1` returned `zsh: no matches found` before `gh` ran
**verified:** 2026-10-06, unquoted `gh api repos/sliday/resume-job-matcher/commits?per_page=5` and `gh api repos/sliday/resume-job-matcher/git/trees/main?recursive=1` each returned `zsh: no matches found`; quoted GET retries using the verified default branch `master` returned 5 commit SHAs in 205 bytes and 49 tree paths in 997 bytes
**verified:** 2026-10-06, unquoted `gh api repos/magicapple123/ResumeForge/commits?per_page=10` returned exactly `zsh: no matches found`; the quoted GET retry returned 54,679 bytes containing 10 commits
**verified:** 2026-10-06 at 2:55 am Pacific, unquoted `gh api repos/selfishprimate/seekter/git/trees/main?recursive=1` returned exactly `zsh: no matches found: repos/selfishprimate/seekter/git/trees/main?recursive=1`; quoting the endpoint fixed the shell failure
**verified:** 2026-10-06, unquoted `gh api` endpoints for `bananatruck/clanker.tracker` tree recursion, `eric-muganga/jobApplicationTrackerApi` commits, `TusharVashishth/localcv` tree recursion, and `rendercv/rendercv` tree recursion each returned `zsh: no matches found` before `gh` ran; the clanker error identified shell line 11, and the other supplied corrections quote the entire endpoint
**verified:** 2026-10-06, unquoted `gh api repos/Hashsharma/ATS-Resume-Checker/commits?per_page=10` and `gh api repos/Hashsharma/ATS-Resume-Checker/git/trees/main?recursive=1` each failed before `gh` ran with `zsh: no matches found`; earlier metadata and README commands in the same invocation batch succeeded
**verified:** 2026-10-06 at 6:16 am Pacific, unquoted `gh api repos/machadop1407/job-application-tracker/commits?per_page=10` and `gh api repos/machadop1407/job-application-tracker/git/trees/main?recursive=1` each failed before `gh` ran with `zsh: no matches found`
**verified:** 2026-10-06, two unquoted `gh api` endpoint arguments ending in `?per_page=5` and `?recursive=1` each returned `zsh: no matches found` before `gh` ran, while repository metadata, README, and issues calls in the same batch succeeded
**verified:** 2026-10-06 at 6:55 am Pacific, a shell lookup containing bare unmatched path argument `application*` returned exactly `zsh:1: no matches found: application*` before `rg` ran
**verified:** 2026-10-06, an unquoted `gh api repos/.../contents/...?ref=master` endpoint argument returned exactly `zsh:1: no matches found` before `gh` ran
**verified:** 2026-10-06, after `gh repo view` and README inspection established that `AmruthPillai/Reactive-Resume` moved to `reactive-resume/reactive-resume`, unquoted `gh api repos/AmruthPillai/Reactive-Resume/commits?per_page=5` printed exactly `zsh:8: no matches found: repos/AmruthPillai/Reactive-Resume/commits?per_page=5`, and the unquoted `git/trees/v4?recursive=1` endpoint likewise returned `zsh: no matches found` before `gh` ran
**verified:** 2026-10-06, unquoted `gh api repos/hugounoclaw/ats-checker/commits?per_page=5` failed before `gh` ran with exactly `zsh:1: no matches found`; the endpoint's `?` was exposed to zsh filename generation
**verified:** 2026-10-06 at about 9:00 am Pacific, unquoted `gh api repos/kotarowatanabe107/ats-resume-checker/git/trees/main?recursive=1` failed before `gh` ran with `zsh: no matches found`; repository metadata had already reported default branch `master`, and the quoted `master?recursive=1` retry returned 28 paths
**verified:** 2026-10-06, fresh unquoted `gh api repos/.../commits?per_page=6` and `gh api repos/.../git/trees/main?recursive=1` calls each failed before `gh` ran with exactly `zsh:1: no matches found`; `shell-preflight` rejected unquoted query endpoints, accepted their quoted forms, and its later expanded query-glob, GitHub-field, rm, Python-launcher, Agent Reach, and backtick suite printed `shell-preflight: 33 fixtures passed`
**verified:** 2026-10-06, unquoted `gh api repos/.../commits?per_page=5` and `gh api repos/.../issues?state=all&per_page=10` each failed before `gh` ran with `zsh: no matches found`; quoting the complete endpoint is the verified recovery class already exercised by the preflight fixtures
**where:** forty-four zsh commands in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`, plus the reusable `home/bin/shell-preflight` check in the dotfiles repository

All forty-four failures occurred while zsh parsed unquoted glob or query metacharacters, before the named tool could handle the argument.

**Why:** still held back at n=44 from forty-four shell-command subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** quote every `gh api` endpoint containing `?` or `&`, for example `gh api 'repos/OWNER/REPO/commits?per_page=5'`; pass file filters through quoted `rg --glob` arguments, omit unresolved path globs, and run `rg --files` before uncertain path targets. Run `shell-preflight '<planned zsh command>'` before execution; its tokenizer rejects exposed query metacharacters in `gh` and `gh-axi` API endpoints plus exposed glob metacharacters in `rg` arguments, and its expanded 33-fixture suite passes. Exact historical fixture parity for all forty-four failures remains UNCONFIRMED.

### macOS `date %:z` exited 0 with literal `:z` suffixes at n=3

**verified:** 2026-10-05 at 9:30 pm Pacific, `TZ=America/Los_Angeles date '+%Y-%m-%dT%H:%M:%S%:z'` exited 0 and printed exactly `2026-10-05T21:30:53:z`; `raw_stamp=$(TZ=America/Los_Angeles date '+%Y-%m-%dT%H:%M:%S%z'); print -r -- "${raw_stamp:0:22}:${raw_stamp:22:2}"` printed exactly `2026-10-05T21:30:58-07:00`
**verified:** 2026-10-05 at 11:19 pm Pacific, the same `%:z` command exited 0 and printed exactly `2026-10-05T23:19:02:z`
**verified:** 2026-10-06 at 8:17 am Pacific, `date '+%Y-%m-%dT%H:%M:%S%:z'` printed exactly `2026-10-06T08:17:33:z`, and Node rejected that value as an invalid timestamp
**where:** three macOS zsh timestamp-formatting invocations and one downstream Node parse in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

All three successful `date` exits produced malformed timestamps because this environment's binary did not interpret `%:z`; the evidence does not independently establish the GNU-versus-BSD implementation distinction as the cause.

**Why:** still held back at n=3 from one date binary and environment subject; there are not five observations from five different subjects.
**Fix:** format the offset with `%z`, verify the output is nonempty, then insert the colon with zsh substring expansion as shown in the verified command and require a final `-07:00` or `-08:00` suffix for Pacific time. Python `datetime.now().astimezone().isoformat(timespec='milliseconds')` is an UNCONFIRMED alternative until its output is captured and parsed. This third recurrence requires a preflight that rejects any non-finite `Date.parse` result or malformed Pacific offset; that check remains UNCONFIRMED until implemented and exercised.

### macOS date emitted literal `.3NZ` on 3 millisecond timestamp attempts; Node ISO parsed

**verified:** 2026-10-06, `date -u +%Y-%m-%dT%H:%M:%S.%3NZ` exited 0 and printed exactly `2026-10-06T14:09:30.3NZ`, after which the pipeline reported exactly `Invalid end timestamp`; two isolated reruns printed `2026-10-06T14:09:48.3NZ` and `2026-10-06T14:10:10.3NZ`, and Node `Date.parse("2026-10-06T14:09:30.3NZ")` returned `NaN`
**verified:** 2026-10-06, `node -e 'console.log(new Date().toISOString())'` printed `2026-10-06T14:09:49.316Z`; a second Node run printed `2026-10-06T14:10:10.118Z` and confirmed `Number.isFinite(Date.parse(value))` was `true`
**where:** three macOS UTC timestamp-formatting invocations and two Node replacement invocations in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The three successful `date` exits all contained a literal `.3NZ`, but the evidence does not establish behavior outside this date binary and machine environment.

**Why:** REJECT at n=3 from one date binary and environment subject; there are not five observations from five different subjects.
**Fix:** generate millisecond UTC timestamps with `node -e 'console.log(new Date().toISOString())'`, then require a finite `Date.parse` result before using the value; both Node replacement outputs were verified.

### macOS date returned `Failed conversion` twice for one valid fractional-second ISO timestamp

**verified:** 2026-10-06, `date -j -f '%Y-%m-%dT%H:%M:%S.%NZ' '2026-10-06T13:13:58.429Z'` printed a first line beginning exactly `Failed conversion of` for that timestamp and format, followed by exactly `date: illegal time format`; a current isolated rerun produced the same two lines
**where:** two macOS date parsing invocations in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

Node parsed the same timestamp and `Intl.DateTimeFormat` printed `10/06/2026, 6:13:58 AM PDT`, confirming that the input timestamp itself was valid.

**Why:** REJECT at n=2 from one date binary and environment subject; there are not five observations from five different subjects.
**Fix:** use Node `Intl.DateTimeFormat` for the timestamp, or strip the fractional part and parse `2026-10-06T13:13:58Z` with BSD date format `%Y-%m-%dT%H:%M:%SZ`; the normalized command printed exactly `2026-10-06T13:13:58Z`.
