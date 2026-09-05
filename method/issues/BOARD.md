# BOARD - the stream agent

Generated from `method/issues/` on 2026-09-02 by `/prd-to-issues`, cut from
`prd-stream-agent.md`. Regenerate after any issue change: the issue files are the truth
and this file is the view.

**Nothing gets built until Zayah has overviewed this and said so.**

| Ready - AFK | Ready - human | Blocked | Done |
| --- | --- | --- | --- |
| 001 Run the agent cold |  | 002 Say one sentence and YouTube goes  (needs 001) | |
|  |  | 003 Generate a YouTube description tha (needs 001) | |
|  |  | 004 Watch the terminal during a stream (needs 002) | |
|  |  | 005 A viewer looks at the overlay and  (needs 001) | |
|  |  | 006 Say one sentence to stop and get t (needs 002) | |
|  |  | 007 Open a page the next morning and f (needs 006) | |
|  |  | 008 See a claim rejected, with its rea (needs 007) | |
|  |  | 009 Two endpoints live off one encode, (needs 004) | |
|  |  | 010 Four platforms live at once from o (needs 009) | |
|  |  | 011 One feed showing everyone chatting (needs 002) | |

## Every issue

| # | Type | Blocked by | Stories | What a person can look at |
| --- | --- | --- | --- | --- |
| `001` | AFK | none | 1 | Run the agent cold and it tells you your real OBS scenes, or names the credential it is missing and refuses |
| `002` | human | 001 | 1, 2 | Say one sentence and YouTube goes live, the countdown runs on air, and the main scene arrives at zero |
| `003` | AFK | 001 | none directly - it is what makes stories 1 and 2 safe | Generate a YouTube description that matches the reference byte for byte where it should, and fails loudly where it should not |
| `004` | AFK | 002 | 3 | Watch the terminal during a stream and see upload, dropped frames, and which endpoints are still connected |
| `005` | human | 001 | 6 | A viewer looks at the overlay and understands what is being built today and how far along it is |
| `006` | AFK | 002 | 4 | Say one sentence to stop and get the day's real numbers, plus what we are trying next time |
| `007` | human | 006 | 5 | Open a page the next morning and find yesterday backfilled with impressions, CTR and retention |
| `008` | AFK | 007 | none directly - it is what keeps stories 4 and 5 honest | See a claim rejected, with its reason, instead of a confident number nobody checked |
| `009` | AFK | 004 | none directly - it is what stories 1 and 2 need to mean every platform | Two endpoints live off one encode, and the number showing what that cost |
| `010` | human | 009 | 1, 2 | Four platforms live at once from one sentence, each with its own native title and description |
| `011` | AFK | 002 | 6 | One feed showing everyone chatting and which platform they are on, and a stream that does not care when it dies |

## How to read it

**Ready - AFK** can be worked by an agent with nobody watching. Seven of the eleven.
Three are ready right now and the rest open as their blockers close.

**Ready - human** needs a person in the room. Four, and each for a stated reason:
`002` publishes to a live audience, `005` is on-screen judgement, `007` needs an OAuth
consent flow, `010` needs stream keys that only exist behind a login.

**Blocked** is waiting on another issue, never on a phase number. That is what lets
independent strips run in parallel.

**Done** means the issue's proof command has been run and the issue file says so. A
closed issue is renamed with a `✅-` prefix so the file tree answers "what is done"
without opening anything.

## The chains

    001 ─┬─ 002 ─┬─ 004 ── 009 ── 010
         │       ├─ 006 ── 007 ── 008
         │       └─ 011
         ├─ 003
         └─ 005

`003` and `005` are independent of `002` and can be worked at the same time. So can
`011` once `002` lands. Three agents can be busy from the moment `001` closes.
