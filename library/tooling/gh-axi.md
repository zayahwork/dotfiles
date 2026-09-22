# gh-axi

The GitHub wrapper. Why it is here, and the one output that lies.

## `gh-axi` with no arguments prints `0 open` even when gh is not authenticated

**verified:** 2026-09-02, `gh-axi` on 0.1.35 in `~/github/dotfiles` printed
`issues: 0 open` and `prs: 0 open` and exited 0, while `gh auth status` in the same
shell printed `You are not logged into any GitHub hosts` and `gh-axi issue list` exited
1 with `code: AUTH_REQUIRED`
**where:** the bare dashboard, principle 8, "running with no arguments shows live data"

The dashboard degrades silently. It reads the repo name from the git remote, which needs
no auth, then reports counts it never fetched as zero. The subcommands are correct and
loud about the same failure, so the lie is only in the no-argument form, which is exactly
the one an agent runs first. An agent that opens with `gh-axi` and sees `0 open` will
report a clean board on a repo it never reached.

**Why:** principle 5 wants a definitive empty state rather than an ambiguous blank, and
here it produced a definite number for something unknown. Definitive and unverified are
not the same thing.

**Fix:** never trust a count from the bare dashboard. Run the subcommand, which exits 1
and names `AUTH_REQUIRED`. Check `gh auth status` before believing any zero.

---

---

## gh-axi is pinned at 0.1.35 in a wrapper, and `setup hooks` must not be run

**verified:** 2026-09-02, `gh-axi --version` prints `0.1.35`, and
`~/.local/bin/gh-axi` resolves to the home-manager store path
**where:** `home/bin/gh-axi`, added to `home.nix` beside `gnhf`

Same shape as `gnhf`: a one line wrapper that execs `npx -y gh-axi@0.1.35`, pinned so an
upstream release cannot change what a switch installs. Bump the version in the wrapper
and nowhere else. It ships a `setup hooks` command, principle 7, which writes session
hooks into the agent config outside this repo. That is the untracked mutable state the
npx wrapper exists to avoid, so it stays unrun and the wrapper says so.

**Why it earned a slot:** their published benchmark, 425 runs on Sonnet 4.6, has
`gh-axi` at 100% task success and $0.050 average against plain `gh` at 86% and $0.054.
That is their number, measured on their tasks, not ours.

---

## Held back

### `VALIDATION_ERROR: unknown flag for gh-axi run watch: --exit-status` at n=1

**verified:** 2026-09-22, `gh-axi run watch 35789890059 --exit-status` returned the title's exact error although upstream `gh run watch` accepts `--exit-status`
**where:** one MemeCoin release-monitoring invocation

This observation establishes the wrapper's response for one run-watch invocation, not a general claim about flag compatibility across `gh-axi` commands or versions.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** use `gh-axi run watch <id>` without `--exit-status`, then inspect `gh-axi run view <id>` for the final conclusion.

### `download: ok` with two `--pattern` flags produced only `MemeCoin.exe` at n=1

**verified:** 2026-09-22, `gh-axi release download v0.2.1 --pattern MemeCoin.exe --pattern MemeCoin.exe.sha256 --dir <tmp>` printed `download: ok` but downloaded only `MemeCoin.exe`; `MemeCoin.exe.sha256` was absent, and downstream `wc`, `sed`, and `shasum -c` failed on the missing file
**where:** one MemeCoin v0.2.1 release-download invocation

This observation establishes one multi-pattern download result, not general behavior across tags, assets, or `gh-axi` versions.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** make a second exact `gh-axi release download <tag> --pattern MemeCoin.exe.sha256 --dir <same-dir>` call, then verify both filenames before hashing.

---
