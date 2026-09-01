---
name: prd-to-issues
description: Cut an approved PRD into the kanban board - one issue per phase-strip with blocking edges and AFK/human tags, plus issues/BOARD.md, the kanban view the user overviews before any build starts. Use for /prd-to-issues. Supersedes to-board (2026-08-27).
---

# prd-to-issues

Turn a PRD's journey into the board: one issue file per phase-strip, and
`issues/BOARD.md`, the kanban view. **Nothing gets built until the user has
overviewed the board and said so.** That overview is the point of this skill -
a bad cut costs nothing to fix here and a great deal after three agents have
worked it.

## 1. Read the PRD

Ask for the path if not given (`issues/prd-<slug>.md`). The layers and modules are
already named and confirmed in it - do not re-derive them, and if the PRD's module
list looks wrong, stop and say so rather than silently cutting around it.

## 2. Cut the issues

One issue per phase-strip, from `templates/issue.md`, numbered from the next free
number in `issues/`, written in dependency order so `blocked-by` names files that
exist.

<slice-rules>
- Each issue is a vertical strip through every layer it touches: the one table, the
  one method, the one call, the one thing on screen. Not a layer.
- A completed issue is demonstrable on its own - someone can look at the result.
- Blocking edges, never phase numbers alone.
- Every issue is tagged AFK or human. When in doubt, human - here the worst outcome
  is not a bad commit, it is real mail to real people.
- Every issue names the failing test to write first and the exact command that
  proves it works.
- Every issue lists the user stories it covers, by number, from the PRD. A story
  covered by nothing was dropped; an issue covering nothing is invented work.
</slice-rules>

## 3. Generate the kanban board

Rewrite `issues/BOARD.md` (non-numeric name - the runner's glob ignores it) from
the issue files:

```
# BOARD - <prd name>
Generated from issues/ on <date>. Regenerate after any issue changes; the issue
files are the truth, this file is the view.

| Ready - AFK | Ready - human | Blocked | Done |
| --- | --- | --- | --- |
| 002 first hunt | 001 adapter | 004 armed ramp (needs 001, 003) | |
```

An issue is Ready when nothing in its `blocked-by` is still open, Blocked
otherwise, Done when its proof command has passed and the issue says so.

## 4. The overview - and the wait

Show the board and the one-line issue list: title, type, blocked-by, stories
covered. Then ask, and wait:

1. Granularity right - too coarse, too fine?
2. Blocking edges correct?
3. Anything to merge or split?
4. Right issues marked human?

Iterate until approved. **Build nothing until then.** After approval, each issue is
worked in its own fresh session (the loop for AFK, a person in the room for human),
and the session clears when the issue's proof command has run.

## Local markdown only

Not GitHub Issues, not a tracker. The loop reads this folder directly.
