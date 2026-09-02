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

---

## `goodnight "objective"` ran the last word of the objective, not the objective

**verified:** 2026-09-02, a run launched with a 180 word objective showed up in
`pgrep -af gnhf` as `gnhf --agent claude --worktree --max-tokens 4000000 --max-rate-limit-wait 2h /home/pc/.claude/CLAUDE.md.`
**where:** `home/bin/goodnight`, every objective passed from an agent shell

`herdr pane run <pane> <command>...` joins its arguments into one command line and the
pane's shell splits that again on whitespace, so `goodnight` handing over
`"$0" --here "$objective"` delivered one word per argument. Its parser is
`for arg in "$@"` with `*) objective="$arg"`, which overwrites on every pass and keeps
only the last word. Proved with a script that dumps `"$@"` to a file: unquoted gave
`argc=7`, `printf '%q'` quoted gave `argc=2` with the sentence intact. Only the
agent-shell path was affected, because in a real terminal `goodnight` never round trips
through herdr, and the default objective is a heredoc rather than an argument.

**Fix:** hand `herdr pane run` a single pre-quoted string,
`"$(printf '%q %q %q' "$0" --here "$objective")"`. And because a wrong objective is
silent for as long as the run lasts, `goodnight` now exits 2 on a second positional
argument instead of keeping the last one.
