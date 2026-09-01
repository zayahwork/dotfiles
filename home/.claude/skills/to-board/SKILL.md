---
name: to-board
description: SUPERSEDED by prd-to-issues (Zayah, 2026-08-27) - use /prd-to-issues, which cuts a PRD's phases into the kanban board the user overviews before any build. Kept for the record; the slice rules below still hold inside that flow.
---

> **Superseded 2026-08-27.** `skills/prd-to-issues` is the current flow - same
> slice rules, plus the generated `issues/BOARD.md` kanban view and the
> board-overview gate. What follows remains true and is folded into it.

# to-board

Turn the destination document into files in `issues/`, one per issue, using
`templates/issue.md`.

## 1. Find the source

Ask for the path to the destination document. Read it from the file if it is not already
in context. Explore the codebase if this is a fresh session.

## 2. Name the layers first

**You cannot cut across layers you have not named.** So write them down before drafting
a single slice.

List every layer this work has to pass through to reach a person. In a typical build
that is storage, then the service holding the logic, then whatever wires it into the
existing flow, then the screen. Some builds have more, some fewer, and a layer that
does not have to change is not a layer for this purpose.

This is the step that makes the rest mechanical. The horizontal phases are the raw
material; a vertical slice is a cut taken down through them. Skip this and "cut
vertically" is an instruction with nothing to cut.

## 3. Draft the slices

<slice-rules>
- Each slice delivers a narrow but complete path through every layer it touches: schema,
  service, interface, tests.
- A completed slice is demonstrable on its own. Someone can look at the result.
- Prefer many thin slices over few thick ones.
- Blocking edges, never phase numbers. Numbered phases can only be worked by one agent.
- Every slice is tagged AFK or human.
- Every slice lists the user stories it covers, by number, from the destination document.
</slice-rules>

**Take one thin piece from every layer.** Pick a single outcome a person could watch
happen, then take the smallest amount of each layer that outcome needs, and bundle those
into one issue. Not the whole storage layer. The one table, the one method, the one
call, the one thing on screen.

**Cut vertically, never horizontally.** The default failure is a first issue that builds
the whole data layer, or the whole service, and produces nothing anyone can look at.

**The correct slice is usually bigger than the horizontal one it replaces.** It has to
reach the screen before it can stop, so it will absorb work a horizontal cut would have
spread across three separate issues. A shorter board is often the right board.

## 4. Check your own split before showing it

Run the story-coverage check first, because it needs no judgement about the code:

- **A slice covering few stories, none of which a person could demonstrate, is
  horizontal.** It is a layer wearing a slice costume. Recut it.
- **Every story in the destination document appears on some slice.** A story covered by
  nothing was dropped. A slice covering nothing in the document is invented work.

## 5. Quiz the user

Present the breakdown as a numbered list. For each slice show the **title**, the
**type**, what it is **blocked by**, and the **stories covered**.

Then ask, and wait:

1. Does the granularity feel right, too coarse or too fine?
2. Are the blocking relationships correct?
3. Should any slices be merged or split further?
4. Are the right slices marked human, and the right ones AFK?

Iterate until approved. Do not write any files before that.

This gate is cheap and it is the point of the whole skill. A bad cut costs nothing to fix
here and a great deal after three agents have worked it.

## 6. Write the files

One markdown file per approved slice in `issues/`, named `NNN-short-title.md`, numbered
from the next available number already in that folder.

**Write them in dependency order, blockers first**, so the `blocked-by` field can name
files that already exist rather than numbers that might not.

**Local markdown only.** Do not create issues through the GitHub CLI or any issue
tracker. The AFK loop reads this folder directly, and a tracker would mean an API call on
every pass.

Each issue names the failing test to write first, and the exact command that proves the
slice works.

## On the human tag

Mark a slice `human` when it needs judgement a person has to supply: a design or
architectural decision, anything on the front end where somebody has to look at it,
anything that sends or publishes, and anything whose right answer depends on something
only the client knows.

**Note where we differ from the source method, deliberately.** It prefers AFK wherever
possible, optimising for throughput in a repo where the worst outcome is bad code on a
branch. We work on systems that send real mail to real clients, where the worst outcome
is not a bad commit. So here: **when in doubt, mark it human.** An AFK task that should
have been human produces confident work in the wrong direction with nobody there to catch
it.
