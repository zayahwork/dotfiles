---
name: write-a-prd
description: Turn a finished grilling session into a PRD - the destination AND the journey, in phases. Runs in the same session as the grill, because that context is the valuable tokens. Step one is the purpose-module list in horizontal layers, confirmed by the user before a word of the PRD is written. Use for /write-a-prd. Supersedes destination-doc (2026-08-27).
---

# write-a-prd

The PRD is the entire plan: what done looks like - the destination - and how we get
there - the journey, in phases. It is written immediately after grilling, **in the
same session**. The grilling context is the valuable tokens; clearing it before
writing throws away exactly what the PRD exists to capture. Everything after the
PRD runs in fresh sessions; the PRD and the board are what carry the state across
the clears.

Read `CONTEXT.md` and use its words.

## Step 1 - the purpose modules, confirmed before anything

Do not write the PRD yet. First present the set of purpose modules this build will
create or modify, **arranged as horizontal layers** - storage at the bottom, then
the services holding the logic, then whatever wires it into the existing flow, then
what a person sees. One line per module: name, layer, NEW or changed, its interface
in one line.

Then stop and wait. The user is confirming two things: the modules look right, and
the layers are named cleanly enough to cut through - because the phases in step 2
are vertical strips down through exactly these layers, and you cannot cut across
layers you have not named. A wrong module list poisons every phase downstream,
which is why this gate is cheap and mandatory.

## Step 2 - write the PRD

Only after the modules are confirmed. From `templates/prd.md` into
`issues/prd-<slug>.md` - it lives beside the board it will spawn, and its name does
not start with a digit, so the runner's issue glob ignores it.

The PRD carries everything the old destination document carried - problem, solution
in one paragraph, user stories a person can do, the confirmed module table, the
implementation and testing decisions with reasons, Out of scope filled properly,
Open questions named to the only person who can close them - **plus the journey**:

- **Phases, each one a vertical strip** down through the named layers: the smallest
  amount of each layer one lookable outcome needs. One thing at a time.
- A phase that is "all of one layer" is horizontal building wearing a phase
  costume. Recut it.
- **Every phase ends the same way:** something a person can run and look at, the
  real output pasted, and then CLEAR - the next phase starts in a fresh session
  that reads the PRD and the board, not this session's memory.
- Blocking edges between phases, never bare sequence numbers, so independent
  strips can be worked in parallel.

## Rules that matter more than the format

- Do not polish it and do not read it back to the user - the alignment already
  happened in the grilling.
- If a section is empty because the grilling did not settle it, say so rather than
  filling it in. Never guess an open question closed.
- Write Testing decisions now, not after: the feedback loop, and what a passing
  run looks like, per phase.

Then hand off to `prd-to-issues`.

## When it ships

Delete the PRD like any plan - doc rot does not care what the document is called.
The ADRs and the shipped code are what survive.
