# CONTEXT.md

The shared language. What our words mean here.

This exists because agents dropped into a project without a vocabulary invent one, and
then use twenty words where one would do. It also exists because a person reading a
status update should not have to decode module names to understand what happened.

Two rules. **Every term here is the term used in code, in issues and in conversation.**
And **if a word in this file no longer matches how we actually use it, fix the file**,
because a glossary nobody trusts is worse than none.

---

## The workflow

**Grilling** - the interview that happens before anything is written. The agent asks one
question at a time, each with its own recommended answer, until both sides understand
the same thing. The output is alignment, not a document.

**PRD** - the entire plan: the destination (what done looks like - problem, solution,
user stories, decisions, what was left out) AND the journey (the phases). Written in
the same session as the grilling, after the user confirms the module list. Lives in
`issues/` beside the board it spawns. The current name for what we used to call the
destination document.

**Phase** - one vertical strip of the journey, worked in its own session, ended with
something a person can look at, then a clear. The PRD and the board carry the state
across clears.

**Kanban board** - `issues/BOARD.md`, generated from the issue files: Ready (AFK and
human), Blocked, Done. The user overviews it before any build starts.

**Out of scope** - the section of a destination document recording what was considered
and rejected. This is what makes a definition of done possible.

**The board** - issues with explicit blocking edges, rather than numbered phases. A
numbered plan can only be worked by one agent. A board can be worked by several.

**Vertical slice** - a thin cut through every layer at once, small but runnable end to
end. The opposite of doing all the schema, then all the API, then all the front end.

**Horizontal** - building a layer at a time. Always wrong here, because nothing can be
tested until the last layer lands.

**Tracer bullet** - the same idea as a vertical slice, named for the round that glows so
the gunner can see where the shots are going. The point is feedback during the work
rather than after it.

**AFK** - a task an agent can complete with nobody watching. Tagged on the issue.

**Human in the loop** - a task that requires a person in the room. Alignment and QA are
always this. Front-end judgement usually is.

**The loop** - the script that picks the next unblocked AFK issue and works it.

**QA** - a person using the thing and forming an opinion. Its output is new issues on the
board, not a pass or fail.

---

## How context behaves

**Smart zone** - roughly the first 100K tokens of a session, where the model does its
best work. Not a function of the window size.

**Dumb zone** - everything after. Recognisable by decisions that would have been obvious
an hour earlier.

**Clear** - discard the session and start from the same known state. Preferred.

**Compact** - squeeze the session into a summary and carry it forward. Avoided, because
what carries forward is unpredictable.

**Push** - information sent on every turn, whether it is relevant or not. `CLAUDE.md`.
Expensive, so keep it small.

**Pull** - information the agent fetches when a task fits it. `skills/`. Cheap, so put
almost everything here.

---

## How code is shaped

**Deep module** - a small interface over a lot of functionality. One test boundary around
it catches a great deal. What we want.

**Shallow module** - a small file exporting a little, tangled with many others. Hard for
an agent to navigate and impossible to draw a sensible test boundary around. What agents
produce when nobody is watching.

**Grey box** - a module whose interface and behaviour we know and whose internals we have
deliberately delegated. How a person keeps a sense of a codebase they are not writing.

**Feedback loop** - anything that tells the agent whether the code works. Types, tests,
running it. The quality of these is the ceiling on the quality of the output.

**Doc rot** - a document that outlived the code it described and is now confidently
wrong. Dangerous because agents trust it. The reason finished plans get deleted.

---

## How we talk about state

**UNCONFIRMED** - stated but not verified. Goes on the claim itself, not in a footnote.

**Verified** - a written check exists and it passed. Not the same as built, not the same
as it seemed to work.

**Staged** - built and sitting somewhere, not in service. Not done.

**Armed** - a switch that lets something send, publish or delete is currently on. Always
named explicitly, never assumed.
