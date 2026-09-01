---
name: qa
description: Use the thing as a person would and form an opinion. Human only. Its output is new issues on the board.
---

# qa

**This is not an agent task.** It is the point where a person imposes taste on the work,
and it is the one stage that must not be automated. A pipeline that automates the idea,
the research, the prototype and the QA produces things that lack taste and often do not
work.

Use it. Not read it, not test it. Open it and do the thing a user would do.

**The output is issues, not a verdict.** Everything found goes onto the board as a new
issue with its blocking edges. QA does not pass or fail a build; it feeds it.

**Do it while implementation is still running.** The board absorbs new issues at any
time, so there is no reason to wait for the loop to finish before looking at what it has
already produced.

Three things worth checking every time, because they are what agents get wrong:

- Does it work on real data, not the shape of data the tests use.
- Does it fail loudly. A quiet failure and a quiet success look identical later.
- Does it do more than the issue asked. Extra work is scope that nobody reviewed.
