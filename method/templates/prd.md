# PRD: <what this builds>

> Written in the same session as the grilling, right after it - that context is the
> valuable tokens. The module list below was confirmed by the user before this was
> written. If a section is empty because the grilling did not settle it, say so
> rather than filling it in.

**Status:** draft | modules-confirmed | board-cut | building | shipped
**Grilled:** YYYY-MM-DD
**Owner:**

---

## Problem

Whose problem, in their words where possible. What it costs them today, with the
source of any number.

## Solution

One paragraph. What the thing does, not how it is built.

## User stories

Things a person can do and what comes back - these are what QA checks.

- As <someone>, I can <do a thing>, and <what comes back>.

## Purpose modules, confirmed <date>

The horizontal layers, named, with every module this build creates or changes.
Confirmed by the user before the rest of this document existed.

| Layer | Module | New or changed | Interface, in one line |
| --- | --- | --- | --- |

## The journey

The phases. Each phase is one vertical strip down through the layers above: the
smallest amount of each layer one lookable outcome needs. Each ends with something
a person can run and look at, then CLEAR - the next phase starts in a fresh session
that reads this PRD and the board.

| Phase | The strip - what a person can look at when it is done | Layers touched | Blocked by |
| --- | --- | --- | --- |

## Implementation decisions

One line each, with the reason. Decisions from the grilling carry the user's date.

## Testing decisions

The feedback loop per phase, what a passing run looks like, and what would catch
this breaking again later.

## Out of scope

**Not optional.** What was considered and deliberately rejected, and why. Without
it there is no definition of done.

## Open, and who can close it

Name the person and the question. Never guess one closed.

---

## When this ships

Delete this file. The decision record in `docs/adr/` is what survives.
