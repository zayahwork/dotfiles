---
name: implement
description: Work one issue from the board, test first, and stop. Used by the AFK loop and by hand.
---

# implement

One issue. Not two.

1. Read `CONTEXT.md` and use its words.
2. Read the issue, including its Not this issue section.
3. **Write the failing test first.** Confirm it fails, and that it fails for the reason
   you expect rather than some unrelated one.
4. Make it pass with the smallest change that does so.
5. Run the feedback loop named on the issue. Paste the real output, including failures.
6. Commit once, referencing the issue.

**Why test first rather than tests after.** A model that writes the whole implementation
and then a test layer underneath it will write tests that agree with whatever it built.
Writing the test first instruments the behaviour before the code exists, which is much
harder to game.

**If you cannot finish it**, say so plainly and leave the issue open. A half slice
committed and described as done is worse than an unfinished one, because the board now
lies.

**Do not review your own work here.** That is a separate pass in a clear session.
