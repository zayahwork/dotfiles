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
