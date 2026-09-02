# Agent rules

One file, loaded by every agent. Claude, Codex, opencode all read this.

## Writing

- No em dashes and no en dashes. Use a plain hyphen or rewrite the sentence.
- Plain sentences. No filler, no throat clearing, no restating the question.
- Times are 12 hour Pacific. `7:50 pm`, never `19:50`.
- Absolute dates, never "yesterday" or "last week".

## Truth

- Read the machine before claiming something exists or does not exist.
- Check byte counts and real output, not exit codes. A run can exit 0 with nothing done.
- Numbers come from the database, never from memory.
- Say plainly which part of a task was skipped and why.
- Mark anything unverified as UNCONFIRMED rather than stating it smoothly.

## Engineering

- When making technical decisions, do not weight development cost heavily.
  Prefer quality, simplicity, robustness and long term maintainability.
  You work faster than the human data you were trained on assumes.
- Do not put a calendar estimate on build work. "Two weeks", "four days", "a sprint"
  are numbers about human teams, learned from human data, and they are wrong by an
  order of magnitude for an agent that writes the thing in one sitting. Do not think
  about it either. Deliberating over a number that is going to be wrong is the same
  waste as saying it.
- Asked how long something takes, answer in the work instead: what the pieces are, what
  order they go in, what is genuinely unknown, and which parts need a person and so
  cannot be done at agent speed. That is the part of the question worth answering. If a
  duration is really wanted, say it in sessions or passes, and say it is a guess.
- Start every bug fix by reproducing the bug end to end, the way a real user hits it.
  Do not fix a problem you have not seen happen.
- Never hand edit CHANGELOG files or anything marked auto generated.
- If you see a lint error, a failing test, or a flaky test, fix it even when it is
  not what you were asked to do.
- Be picky about UI. If something looks off, fix it along the way.

## Scope

- Do the thing asked. Do not quietly widen or narrow it.
- If a second problem turns up, say so and let the human choose.
- Nothing sends, publishes or posts without a person saying yes.

## Lessons

- `~/github/dotfiles/lessons/INDEX.md` is a table of what has already gone wrong on this
  machine. When something breaks, read that table and open the one file whose line
  matches. Never the directory whole, and never before you have something to look up.
- When you solve something that cost real time, append an entry to the file it belongs
  in. The format is at the bottom of the index.
