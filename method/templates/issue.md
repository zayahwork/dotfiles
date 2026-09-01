# <one line, what a person can do when this is done>

**id:** NNN
**type:** AFK | human
**blocked-by:** none | NNN, NNN
**slice:** vertical | infrastructure
**stories:** <user story numbers from the PRD this issue delivers, e.g. 9, 11>
**from:** <destination document this came out of, or QA if it was found by using the thing>

---

## What done looks like

The observable result. A person doing a thing and getting something back. If nobody can
look at the outcome of this issue and tell whether it worked, it is not a vertical slice
and it needs splitting differently.

## Modules touched

Named from the destination document. If this issue needs a module that is not on that
list, stop and say so rather than inventing one.

## The failing test to write first

The specific test that should fail before any implementation exists, and the reason it
should fail. Confirm it fails for that reason and not some other one.

When the issue writes no code, this is not optional and it is not "n/a": name the
written check that stands in for it (a numbered check in the project's regression set),
and the failing state it must move away from - the observable thing that is wrong now
and will be right when the issue closes. A check with no subject yet still fails; say so.

## Feedback loop

The exact commands that tell you whether this works, and what a passing run prints.

## Not this issue

What a reader might reasonably assume is included and is not. Keeps the slice thin and
stops scope leaking in during implementation.

---

## Why `type` matters

`AFK` means the loop can pick this up with nobody watching. `human` means it cannot,
and the loop must skip it.

Mark it `human` when the work needs judgement that only a person has: anything where the
answer is a matter of taste, anything touching the front end where somebody has to look
at it, anything that sends or publishes, and anything where the right answer depends on
something only the client knows.

When in doubt, mark it `human`. An AFK task that should have been human produces
confident work in the wrong direction, and nobody is there to catch it.
