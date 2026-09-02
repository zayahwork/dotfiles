# The Method

How we run builds. Copied here so it is never lost with a project.

This encodes a workflow for building software with agents. The method it is based on
comes from Matt Pocock's workshop "Full Walkthrough: Workflow for AI Coding" and the
books he draws on, chiefly The Pragmatic Programmer and Ousterhout's A Philosophy of
Software Design. Credit there; mistakes here.

---

## The method in nine lines

1. Keep every task inside roughly 100K tokens.
2. Clear context rather than compacting it, and keep the always-on prompt small.
3. Start with a grilling session. Alignment is the deliverable, not the document.
4. Write a destination document. Do not read it and do not polish it.
5. Split it into a board of blocking issues, cut as vertical slices, each tagged AFK or
   human.
6. Let the agent work the AFK backlog while you are away.
7. Test first, review in a fresh context, gate every strip through `/no-mistakes`, let
   `gnhf` attack the finished build, then QA by hand.
8. Feed everything QA finds back onto the board.
9. Keep the modules deep, because the shape of the code is the ceiling on the agent.

---

## The loop

```
idea
  |
  v
grill          <- human in the loop, always. Cannot be automated.
  |
  v
prd            <- the destination AND the journey, in phases. Written in the same
  |               session as the grill (those are the valuable tokens), after the
  |               user confirms the module list in horizontal layers. /write-a-prd
  v
kanban board   <- /prd-to-issues. One issue per phase-strip, blocking edges,
  |               AFK or human. The user overviews issues/BOARD.md before any
  |               build starts.
  v
implement      <- one issue per session, then CLEAR. AFK issues run unattended.
  |
  v
review         <- fresh context, standards pushed in
  |
  v
no-mistakes    <- /no-mistakes, once per vertical strip, as each strip finishes.
  |               Not at the end. A strip that has not passed the gate is not
  |               done, and the next strip does not start on top of it.
  v
gnhf           <- /gnhf, once, when the whole build is finished. An agent uses
  |               the thing as a new user would and hunts for what breaks.
  |               Its output is issues, not a pass.
  v
QA             <- human. This is where taste enters.
  |
  +--> new issues go back on the board
```

Everything above the board is human. Everything below implement is where the human
comes back. The middle is the only part that runs unattended.

**Two gates, and they are at different scales.** `/no-mistakes` runs per vertical strip,
the moment that strip is finished, because a strip that has not passed is not done and
the next one must not be built on top of it. `gnhf` runs once, at the end, against the
whole thing, because the bugs it is looking for only exist where strips meet. Running
`gnhf` per strip finds nothing the strip's own tests did not, and running `/no-mistakes`
only at the end means finding a broken foundation after four things were built on it.

---

## What is here

| Path | What it holds |
| --- | --- |
| `CONTEXT.md` | The shared language. What our words mean, so nobody writes twenty when one will do. |
| `templates/` | Destination document, PRD, issue, regression set. |
| `issues/BOARD.md` | The kanban view, generated from the issue files. Empty until a PRD is cut. |

The skills live outside this folder, at `../home/.claude/skills/`, because they deploy
to `~/.claude/skills/` and are meant to be available in every project rather than only
this one.

| Skill | When it fires |
| --- | --- |
| `grill` | Before anything is written. One question at a time, each with a recommendation. |
| `write-a-prd` | Same session as the grill. The destination and the journey. |
| `prd-to-issues` | Cut the approved PRD into a board of blocking issues. |
| `to-board` | The older cut. Superseded by `prd-to-issues` on 2026-08-27, kept for its slice rules. |
| `destination-doc` | The destination document format. |
| `implement` | Working one issue, one session. |
| `review` | Fresh context, never the session that wrote the code. |
| `qa` | A person using the thing. Output is new issues, not a pass or fail. |
| `no-mistakes` | Per vertical strip, as it finishes. Review, tests, lint, docs, CI. A strip that has not passed is not done. |
| `gnhf` | Once, on the finished build. An agent spins the thing up as a new user and finds what breaks. |

---

## Starting a project from this

Copy `CONTEXT.md`, `templates/` and an empty `issues/` into the new repo, write a small
`CLAUDE.md` for the push layer, then grill. The skills are already global, so there is
nothing to copy for those.

---

## Two rules about any repo built this way

**The push layer stays small.** `CLAUDE.md` is sent on every single turn. Anything that
is only sometimes relevant belongs in a skill behind a description, where the agent
pulls it when the task fits. A large always-on prompt starts every session already
tired.

**Finished plans get deleted.** A destination document that outlives its build becomes a
confident, wrong description of code that has moved on, and the next agent will believe
it. Ship it, then remove it. The decision record in `docs/adr/` is what survives.
