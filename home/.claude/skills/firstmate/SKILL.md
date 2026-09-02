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

**It is read-only over your projects by default.** The first mate itself does not edit
your repos; crewmates do, each in its own treehouse worktree, behind the configured
merge authority.

**Every crewmate is visible.** Each gets its own tmux window, herdr tab, cmux workspace
or Orca terminal you can watch or type into. herdr is supported, which is why it is
worth trying here, though tmux is the hard default and the backend it is best tested on.

**It needs `gh`.** Authenticated on this machine as zayahwork, scopes `gist`,
`read:org`, `repo`. See `library/tooling.md`.

## Current guidance lives in the repo

`~/github/firstmate/AGENTS.md` and `~/github/firstmate/docs/architecture.md`. Do not
follow anything in this file over those; this one only says where it is and what
adopting it costs.
