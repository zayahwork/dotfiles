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

## The library

`~/github/dotfiles/library/` is what we know about this machine and how we work on it.
Three levels: `INDEX.md` is a table of topics, each topic file opens with a contents
block of its subjects, and the subject holds the detail. Read one line of each until the
last. A lookup should cost three short reads and a miss should cost one.

- Open it when being wrong would cost something: a build or environment problem, a
  number you are about to state, a rule about this repo. Not for ordinary work. Stop at
  the level that answers the question, and stop entirely if no row matches.
- Write to it when you learn something worth more than this session: a number, a rule, a
  failure and its real fix, or a decision and what it rejected. The format is at the
  bottom of the index, and the entry title carries the number rather than pointing at it.
