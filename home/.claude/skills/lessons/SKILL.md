---
name: lessons
description: The log of what has already gone wrong on this machine - tools, builds, environment, agent config. Read it when something breaks or behaves oddly before you start guessing, and write to it after solving something that cost real time.
---

# lessons

The log lives in the repo, at `~/github/dotfiles/lessons/`. Not in `~/.claude/`, which
is a read-only Nix store symlink and cannot be appended to.

## Reading

1. Read `~/github/dotfiles/lessons/INDEX.md`. It is one table, a few lines long.
2. Open **one** file, the one whose description matches what you are actually doing.
3. If no row matches, stop. Nothing there is going to help, and reading the rest of the
   directory to be sure costs more than it can return.

The point of the two hops is that the index is cheap and the files are not. Do not
pre-load them, do not grep the directory as a substitute for reading the table, and do
not open a second file because the first was interesting.

## Writing

Append when something cost real time and the next agent would hit it the same way. A
typo is not an entry. Neither is a thing you worked around without understanding.

The entry format is in `INDEX.md`, at the bottom, and it is short. Follow it exactly.

Two things it is easy to get wrong:

- **Only what happened.** Verified on this machine, with the real error text if it is
  short. If the cause was never confirmed, write UNCONFIRMED in the Why line. A smooth
  guess in this log is worse than a gap, because the next agent will act on it.
- **The Fix line is what worked**, not what should have worked and not the first thing
  you tried.

New file only when the thing has no home on the table. When you add one, add its row to
the index with a description a stranger could match against on one read - the row is the
only part most agents will ever see, so a vague one makes the file invisible.

An entry that turns out to be wrong gets deleted, not corrected in place.

## Committing

`lessons/` is tracked. Commit the entry with the work that produced it, or on its own if
the work went nowhere - a dead end is exactly the thing worth recording.
