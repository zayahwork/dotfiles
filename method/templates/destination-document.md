# <what this builds>

> Written once, after grilling. Not polished, not read back. If a section is empty
> because the grilling did not settle it, say so rather than filling it in.

**Status:** draft | approved | building | shipped
**Grilled:** YYYY-MM-DD
**Owner:**

---

## Problem

Whose problem, in their words where possible. What it costs them today. If the number
came from a real measurement, say where. If it is an estimate, say so on the line.

## Solution

One paragraph. What the thing does, not how it is built.

## User stories

One line each, in the form of someone doing something and getting something back. These
are what QA will actually check, so write them as things a person can do rather than as
features.

- As <someone>, I can <do a thing>, and <what comes back>.

## Modules touched

The list of modules this will create or change, named before any code exists. New ones
are marked NEW and get a one line description of their interface.

| Module | New or changed | Interface, in one line |
| --- | --- | --- |

Keeping this list is what stops the build drifting into a pile of shallow files.

## Implementation decisions

Decisions taken during grilling that constrain the build. One line each, with the reason.

## Testing decisions

How this gets verified, decided now rather than after. What the feedback loop is, what a
passing run looks like, and what specifically would catch this breaking again later.

## Out of scope

**This section is not optional.** What was considered and deliberately rejected, and why.
Without it there is no definition of done, and the next session will re-open settled
questions.

## Open, and who can close it

Anything the grilling could not settle because only a specific person can answer. Name
the person and the question. Do not guess these.

---

## When this ships

Delete this file. The decision record in `docs/adr/` is what survives. A destination
document that outlives its build becomes a confident description of code that has moved
on, and the next agent will believe it.
