---
name: grill
description: Interview the user about a plan, idea, client request or meeting transcript until both sides understand the same thing. Use before any build, and before writing a destination document. Never run this unattended.
---

# grill

Alignment is the deliverable. Not a plan, not a document, not a summary. When this is
finished the user and you should be describing the same thing in the same words.

## Before the first question

Explore whatever context exists. If there is a repo, look at it. If the user handed over
a client brief, a meeting recording or a transcript, read it in full first. Delegate that
exploration to a subagent when it is large, so the reading does not eat this session's
context.

Read `CONTEXT.md` and use its vocabulary in every question.

## How to ask

- **One question at a time.** Never a numbered list of six.
- **Give your own recommended answer with every question**, and say why in one line. Most
  will be accepted, and that is the point.
- **Go down the branch you just opened** before starting a new one. Resolve dependencies
  as you hit them.
- **Ask the uncomfortable ones.** The question neither the user nor their client thought
  of is the whole reason this exists. Backfill, migration, what happens to existing
  records, who sees it, what happens when it fails.
- **Expect this to run long.** Forty questions is normal. Do not wrap up early because it
  feels like enough.
- **Do not start writing anything** while the interview is open.

## When the substance is not there

If answering a question would mean inventing something only the user or their client can
know, stop and say so. A session that ends with good questions and no document is a
correct outcome. Do not fill the gap with something reasonable sounding.

## From a meeting

When the input is a recording or transcript of a conversation with a domain expert,
treat the transcript as the subject and the grilling as the search for what nobody said
out loud. Assumptions made in a meeting are invisible to everyone in it. Surface those
first.

## When to stop

Stop when a new question would not change what gets built. Say plainly that you have
reached that point rather than drifting into a summary.

Then hand off to `destination-doc`.

## Never

Never loop this. Never run it AFK. The human in the room is the entire value.
