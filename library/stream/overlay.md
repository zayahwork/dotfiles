# The overlay and the task board

What viewers see on screen and what feeds it.

## Contents

- [The task board is for viewers, so it never shows the repo](#the-task-board-is-for-viewers-so-it-never-shows-the-repo)
- [An agent may push to the board only when an issue changes state](#an-agent-may-push-to-the-board-only-when-an-issue-changes-state)

---

## The task board is for viewers, so it never shows the repo

**verified:** 2026-09-02, specified by Zayah in the stream agent grill
**where:** the on-stream task board

It shows a general topic in a few words, what has to be done today, the schedule,
and a percent bar. No file names, no commits, no diffs, no issue ids, no branch names.
Somebody watching should understand what is being worked on without knowing anything
about the codebase.

**Why:** The moment developer vocabulary appears on it, the board has stopped being for the
audience. It also never competes with the two display screens, because the screens are
the stream.

## An agent may push to the board only when an issue changes state

**verified:** 2026-09-02, decided in the stream agent grill
**where:** what agents send to the task board

Started, finished or blocked, and at no other time. "Push if it is important" cannot
be left to each agent to judge, because every agent believes its own work is important and
the result is five hours of noise on camera.

**Why:** A state change is important by definition, and the rule needs no model in the loop,
which is the same argument as the deterministic core.
