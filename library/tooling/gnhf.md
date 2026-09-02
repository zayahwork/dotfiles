# gnhf

The autonomous loop. What ends a run, and where it keeps its state.

## gnhf stops on a cap, on `--stop-when`, or on three failures, never on the objective

**verified:** 2026-09-01, `gnhf --help` on 0.1.47 offers no completion flag other than
`--stop-when`, and `maxConsecutiveFailures: 3` is a hard coded default in its `dist/cli.mjs`
**where:** the `gnhf` skill, and any unattended run

Nothing in gnhf notices that an objective is finished, so an uncapped run hands the same
objective to a fresh iteration forever. A run ends on `--max-iterations`, on
`--max-tokens`, on an iteration reporting the `--stop-when` condition met, on three
consecutive failed iterations, or on a permanent agent error such as a low Claude credit
balance. A no-op iteration counts as a failure, which is the only way a run with nothing
left to do stops itself. Two refusals before any of that: `Working tree is not clean.
Commit or stash changes first.` and `Cannot combine --current-branch and --worktree.`

**Fix:** the `gnhf` skill said "until the objective is met or a cap stops it" and named
no stop condition. It now has a "What actually ends a run" section listing all five,
plus the two refusals.

---

---

## gnhf hides its run state in `.git/info/exclude`, not in `.gitignore`

**verified:** 2026-09-01, from a gnhf worktree, `git check-ignore -v .gnhf/runs` printed
`/home/pc/github/dotfiles/.git/info/exclude:7:.gnhf/runs/`
**where:** any repo gnhf has been run in, and every worktree of it

Prompt, notes, per-iteration jsonl and the run log live under `.gnhf/runs/<runId>/` in
the working directory, and gnhf keeps them out of the branch by appending to the repo's
exclude file rather than to a tracked `.gitignore`. The pattern is `.gnhf/runs/`, so
`git check-ignore .gnhf` exits 1 and the rule looks absent until you ask about the
`runs/` path itself. Worktrees share one exclude file through the common git dir, which
is why a run inside a worktree writes into the main checkout's `.git/info/exclude`.

---
