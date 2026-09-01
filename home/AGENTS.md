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
