# Stream

The live stream and its numbers, and the stream agent that runs it. The full plan with
its reasoning is `method/issues/prd-stream-agent.md`; this is the lookup, so an agent can
check one fact without reading the plan whole.

One line per subtopic below. Open the one file you need, not this whole subtree.

## Contents

| Subtopic | What is in it |
| --- | --- |
| [`titles.md`](titles.md) | The day-counter formula does 16K-77K where off-formula does 5.4K-5.9K on the same channel. A model release in the title did 115K. |
| [`descriptions.md`](descriptions.md) | The 21 blocks, 1,506 characters fixed and 1,247 written fresh. A 49,200 subscriber channel with empty descriptions gets 43-146 views. |
| [`going-live.md`](going-live.md) | OBS stays the encoder, the countdown runs on air, one word from a human publishes, and four copies at 6 Mbps fit in 65 up. |
| [`machine.md`](machine.md) | The live path is a terminal on the Acer. GitHub Actions cannot reach obs-websocket, and takes the scheduled work instead. |
| [`overlay.md`](overlay.md) | The task board never shows the repo, and an agent may push to it only when an issue changes state. |
| [`measuring.md`](measuring.md) | Impressions and CTR are owner-only. A live broadcast cannot be split-tested. Five observations against the untouched drift, or no claim. |
| [`platforms.md`](platforms.md) | The channel is `@ZayBuilds-b6o`, not `@CorpAI`. X has never gone live so ingest is UNCONFIRMED. Two framings costs a second encode. Kick and Twitch exist, unconfigured. |
| [`credentials.md`](credentials.md) | Stream keys may live in this private repo, approved 2026-09-02, and what that costs in git history and Actions logs. |

---

## Two tiers inside every subject

Tier one is what `library-admin` passed. Tier two, under a `Held back` heading, is what
it rejected, kept with the reason and the numbers so far, because a claim rejected at n=3
is a claim at n=3 and not a lie. Read tier one. Drop to tier two only if tier one did not
answer the question.
