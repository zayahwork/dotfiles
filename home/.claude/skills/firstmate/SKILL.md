---
name: firstmate
description: Run a crew of agents through a single liaison - you talk to the first mate, it spawns supervised agents in their own worktrees and hands back finished work. Read this before launching it, because launching it replaces the method in method/ rather than extending it.
---

# firstmate

Not a CLI, not an MCP server, not a package. The cloned repo **is** the distro: an
`AGENTS.md`, a set of skills and helper scripts that turn a general purpose agent into a
first mate when you launch a harness inside that directory.

Cloned to `~/github/firstmate`. Nothing about it is installed, and nothing runs until
somebody launches it.

## Launching

```sh
cd ~/github/firstmate
claude
```

Its `AGENTS.md` takes over from there and you are the captain. Claude Code is one of its
three co-primary harnesses, using a tracked Stop hook so the watcher re-arms without
spending tokens.

## Read this before you launch it

**It replaces the method, it does not extend it.** `method/` here is grill, PRD, board,
implement, review, QA, with the human in the loop at the top and bottom. firstmate has
its own lifecycle: intake, ship or scout tasks, supervision, escalation, and a merge
authority per project. Running both means running two answers to the same question.

**It works on its own clones, not on yours.** A project is cloned to
`$FM_HOME/projects/<name>`, which is `~/github/firstmate/projects/<name>` unless you set
`FM_HOME`. Your existing checkout is never touched. The first mate is read-only over
that clone and crewmates do the editing, each in its own treehouse worktree, behind that
project's mode: `no-mistakes` (pipeline, PR, merge authority), `direct-PR` (push and PR,
no pipeline) or `local-only` (local branch, no remote), with an orthogonal `+yolo` that
lets it merge green without asking. Read-only is a default, not an absolute: hard rule 1
carves out project init, fleet sync, secondmate sync, self-update, approved `local-only`
merges, and one concrete operation you approve in the moment.

**Every crewmate is visible.** Each gets its own tmux window, herdr or zellij tab, cmux
workspace or Orca terminal you can watch or type into. tmux is the hard default and the
only backend its own docs do not mark experimental; herdr, zellij, cmux and Orca all
carry that label.

**On this machine it picks herdr, not tmux.** Our shell runs inside herdr, so
`HERDR_ENV=1` is in the environment and `fm_backend_detect` auto-selects the
experimental herdr backend before it ever reaches a default. Only `TMUX` being set
outranks it. Pass `--backend tmux`, or write `tmux` into `$FM_HOME/config/backend`, to
get the backend the docs are written for. See `library/tooling/firstmate.md`.

**It needs `gh`.** Authenticated on this machine as zayahwork, scopes `gist`,
`read:org`, `repo`. See `library/tooling/installing.md`.

## Current guidance lives in the repo

`~/github/firstmate/AGENTS.md` and `~/github/firstmate/docs/architecture.md`. Do not
follow anything in this file over those; this one only says where it is and what
adopting it costs.
