---
name: library
description: The library at ~/github/dotfiles/library - what is known about this machine and how we work on it, kept as numbers, rules and failures rather than prose. Read it when a question matters enough that being wrong would cost something, and write to it when you learn something worth more than this session.
---

# library

Lives at `~/github/dotfiles/library/`, in the working tree. Not in `~/.claude/`, which
is a read-only Nix store symlink and cannot be appended to.

## Reading, three levels, one line at a time

1. `library/INDEX.md`. One table, one row per topic.
2. The **contents block** at the top of the one topic file whose row matched. Roughly
   the first 15 lines. Its subjects, one line each.
3. The one subject you came for.

Stop at any level that answers the question, and stop entirely if nothing matches. Do
not pre-load topics, do not grep the directory as a substitute for reading the table,
and do not open a second file because the first was interesting. The whole design is
that a lookup costs three short reads and a miss costs one.

A topic past roughly 150 lines is a directory instead, `topic/INDEX.md` plus one file
per subject. Same three levels, same rule.

## When to open it at all

When being wrong would cost something: a build, an environment or tool problem, a
number you are about to state, a rule about this repo, a thing that smells like it has
bitten someone before. Not for ordinary work you already know how to do. A question
that does not matter is not worth even the index.

## Writing

Write when the thing has value past this session. Four kinds earn an entry:

- a **number** - a limit, a size, a version, a measured result
- a **rule** - something that must or must not be done, and what happens otherwise
- a **failure** - what broke, why, and what actually fixed it
- a **decision** - what was chosen, what was rejected, and the reason

The format is at the bottom of `INDEX.md`. Three things it is easy to get wrong:

- **The description is the content.** A row or title reading "notes on keybindings" is
  invisible. Put the number, the exact key, the version, the rule into the line itself.
  Under five sentences everywhere, and the index row is one.
- **Only what happened or what was measured**, on this machine, with the real output.
  A number from memory is not a number. Unconfirmed cause, write UNCONFIRMED.
- **Add the subject to the contents block** of its topic file in the same edit. An
  entry nobody can reach from that block is not in the library.

New topic only when the thing has no home on the table, and its row goes in the index
with a description a stranger could match against in one read.

An entry that turns out to be wrong gets deleted, not corrected underneath.

## Committing

`library/` is tracked. Commit the entry with the work that produced it, or on its own if
the work went nowhere. A dead end is exactly the thing worth recording.
