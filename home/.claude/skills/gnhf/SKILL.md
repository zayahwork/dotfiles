---
name: gnhf
description: Run an autonomous agent loop that keeps working while nobody is watching - one small committed change per iteration towards an objective, rolled back on failure. Use for an AFK backlog, an overnight run, or any objective worth grinding at rather than doing in one pass.
---

# gnhf

An autonomous loop. Each iteration makes one small change, commits it on success and
rolls it back on failure, until something stops it. You wake up to a branch of clean
commits and a log of everything that happened.

Installed as a pinned wrapper at `~/.local/bin/gnhf`, which execs `npx -y gnhf@0.1.47`.

## Current guidance lives in the CLI

`gnhf --help` is the source of truth for flags. What follows is how we run it here, not
a copy of its interface.

## The shape of a run

```sh
gnhf --agent claude --worktree --max-iterations 1 --max-tokens 500000 "the objective"
```

It refuses to start on a dirty working tree: "Working tree is not clean. Commit or
stash changes first." `--worktree` and `--current-branch` choose different working
directories, so passing both is an error rather than a preference.

Four things about that line:

- **`--worktree` unless you mean otherwise.** It runs in a separate git worktree, so the
  loop cannot collide with whatever is open in your editor, and several objectives can
  run at once on the same repo.
- **Always cap it.** `--max-iterations` and `--max-tokens` are the difference between an
  overnight run and an overnight bill. A first run of anything gets `1`.
- **No `--push` by default.** Commits stay local until a person has looked at them.
  Pushing is a person's call.
- **The objective is a sentence, not a ticket.** It is fed to the agent as the standing
  goal for every iteration, so it has to still make sense on iteration forty.

## What actually ends a run

Nothing in gnhf notices that an objective is finished. Left alone it keeps handing the
same objective to a fresh iteration, so a run ends only when one of these fires:

- `--max-iterations` stops it before the next iteration starts.
- `--max-tokens` aborts mid-iteration once reported usage crosses the cap.
- `--stop-when "<condition>"` ends the loop after an iteration whose agent reports that
  condition met. It is the only way to end on the work rather than on a cap, so give it
  something observable: "the full test suite passes and no unrelated files changed".
- Three consecutive failed iterations. That number is fixed in the tool and has no flag.
  A no-op iteration counts as a failure, which is how a run that has nothing left to do
  eventually stops itself.
- A permanent agent error, such as a Claude credit balance too low to continue.

Re-running `gnhf` on an existing `gnhf/` branch resumes that run rather than starting a
new one, and a resume reuses the saved `--stop-when` unless you pass a new value or
`--stop-when ""` to clear it.

## Judging the result

A run that worked ends with a summary: elapsed time, branch, iterations, token totals,
branch diff stats, and a review command. A run that ends with no commit is a failure
worth reading the log over, not a quiet no-op.

Read the commits before doing anything with the branch. One small committed change per
iteration is the design, which means the branch is a sequence of steps to review, not a
single change to accept or reject.

## Where it fits here

`method/CONTEXT.md` defines the loop as the thing that picks the next unblocked AFK
issue and works it. gnhf is objective-driven rather than board-driven, so it is that
engine without the board attached. Handing it one issue at a time from `issues/` is the
bridge, and it is not built yet.
