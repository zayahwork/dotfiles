---
name: destination-doc
description: SUPERSEDED by write-a-prd (Zayah, 2026-08-27) - use /write-a-prd, which adds the confirmed module gate and the phased journey. Kept for the record; the rules below still hold inside the PRD flow.
---

> **Superseded 2026-08-27.** The PRD is the destination document plus the journey:
> `skills/write-a-prd` is the current flow. What follows remains true and is folded
> into it.

# destination-doc

Compress the grilling session into `templates/destination-document.md`.

Rules that matter more than the format:

- **Name the modules before any code exists.** The module list is the part that keeps
  the build from drifting into a pile of shallow files. If you cannot name them, the
  grilling is not finished.
- **Fill in Out of scope properly.** What was considered and rejected, with the reason.
  Without it there is no definition of done and the next session reopens settled ground.
- **Write Testing decisions now**, not after. Name the feedback loop and what a passing
  run looks like.
- **Leave Open questions open.** If only a specific person can answer, name the person
  and the question. Never guess one closed.

Do not polish this. Do not ask the user to read it back. The alignment already happened
in the grilling session; this is a record of it, and time spent perfecting it is time
not spent in QA.
