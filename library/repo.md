# repo

This repo's own hard rules and the numbers behind them. The canonical text is in
`README.md` and `method/README.md`; this file exists so an agent can check one rule
without reading either of them whole. If the two ever disagree, they are canonical and
this file is the bug.

## Contents

- Branches move `development -> staging -> main`, one direction, no direct commits to the last two.
- Promote with `git merge --no-ff`, never a reset or a cherry-pick.
- `media` is an orphan branch with no shared history. It joins nothing.
- One task, roughly 100K tokens. Clear context, do not compact it.
- This repo is private, so a commit link 404s for anyone not signed in as zayahwork.
- `metrics` reads sessions, git and gnhf notes live. Nothing keeps a ledger.
- Anything in `home/bin/` is held to the `agent-cli` skill, nine checks, adapted from AXI.

---

## Never commit directly to staging or main

**verified:** 2026-09-01, `README.md` Branches section
**where:** every commit in this repo

`development` is the only branch written to directly. A change that appears on `main`
without passing through the other two was never let run anywhere, so the branch stops
meaning anything. Promotion is a claim: `staging` claims the draft is revised, `main`
claims it ran and nothing went wrong. Do not make either claim to tidy up the branches.

**Fix:** `git checkout staging && git merge --no-ff development`, then the same into
`main`. A merge, not a reset or a cherry-pick, so the history says where a change came
from.

---

## media is an orphan branch and never merges

**verified:** 2026-09-01, `git branch -vv`, `media` at `beacbfc` on its own root
**where:** finished media only, no drafts and no project files

It has no history in common with the other three, so switching to it swaps the whole
working tree. Commit before you switch. It is separate because anything committed to a
branch stays in that branch's history forever, and a clone of the config should never
have to carry a video file.

---

## One task, roughly 100K tokens, then clear

**verified:** 2026-09-01, `method/README.md`, first two lines of the method
**where:** how sessions are sized

Clear context rather than compacting it, and keep the always-on prompt small.
`home/AGENTS.md` is sent on every single turn, so anything only sometimes relevant goes
behind a skill description or into this library instead.

---

## Scripts in home/bin are held to the agent-cli skill

**verified:** 2026-09-01, decided after reading <https://github.com/kunchenguid/axi>
**where:** `home/bin/`, and anything an agent shells out to

Our scripts are read by agents and status bars more than by a person, so the bar is
agent ergonomics: say the least that answers, empty is a result rather than silence,
errors are structured and exit non-zero, no interactive prompts. The nine checks are in
the `agent-cli` skill, which is where they belong, because they are only relevant when
you are writing one.

**Rejected:** putting the principles in this library. Every entry here carries a
`verified:` line meaning it was seen on this machine, and an external design spec has no
honest one. Also rejected: installing the upstream AXI skill, which is 15KB written for
published npm CLIs, three of whose ten principles do not apply to a shell script
deployed by home-manager.

---

## The repo is private, so commit links 404 unless you are signed in

**verified:** 2026-09-01, the repo page returns HTTP 404 to an unauthenticated request
and HTTP 200 with the stored credential; the API reports `private: true`
**where:** every link `commit-url` prints

A logged out fetch of `https://github.com/zayahwork/dotfiles/commit/<sha>` gets a 404
whether or not the commit exists, so a 404 says nothing about whether the push worked.
Signed in as the owner it resolves.

**Fix:** when a link comes back dead, check `git ls-remote origin <branch>` rather than
the HTTP status. The usual real cause is that the commit was never pushed, which is what
`commit-url` warns about on stderr.

---

## Every metric comes from a source already on disk, never from a ledger

**verified:** 2026-09-02, `metrics --days 2` reported 7 sessions, 1010 turns, 689K output
tokens, 56 commits, 12K output tokens per commit, all read live
**where:** `home/bin/metrics`

Three sources, none of which anything has to remember to write:

- **sessions** from `~/.claude/projects/<slug>/*.jsonl`, one file per agent session, each
  assistant record carrying `message.usage` with output, thinking, cache write and cache
  read tokens, plus `gitBranch` and a timestamp. The slug is the working directory with
  every `/` and `.` turned into `-`.
- **shipped** from `git log --since`, so commits, files and lines need no recording.
- **loops** from `.gnhf/runs/*/notes.md` inside a gnhf worktree, which is the one source
  that disappears: the worktree is thrown away when the branch is done.

**Why it is read rather than logged:** a ledger has to be written by something that
remembers to write it, and an agent that forgets leaves a gap that looks like idleness.
Reading the sources cannot drift and cannot be forgotten.

**The one thing that does need catching:** a gnhf run's notes die with its worktree. Read
`metrics` before `git worktree remove`, or that run's iteration count is gone.
