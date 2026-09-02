# Stream

The live stream and its numbers, and the stream agent that runs it. Titles, descriptions,
going live, the machine, the overlay, measuring, platforms and credentials. The full plan
with its reasoning is in `stream-agent.md` at the repo root; this file is the lookup, so
an agent can check one fact without reading the plan whole.

Every subject has two tiers. Tier one is what the library admin passed. Tier two, under
a `Held back` heading, is what it rejected, kept with the reason and the numbers so far,
because a claim rejected at n=3 is a claim at n=3 and not a lie. Read tier one. Drop to
tier two only if tier one did not answer the question.

## Contents

| Subject | What it says |
| --- | --- |
| **Titles** | |
| [A day-counter title formula does 16K-77K views on the same channel where off-formula titles do 5.4K-5.9K](#a-day-counter-title-formula-does-16k-77k-views-on-the-same-channel-where-off-formula-titles-do-54k-59k) | BridgeMind, 7 formula streams against 3 off-formula ones, same weeks, same descriptions. |
| [A model release in the title beat every formula title, 115K against a 16K-77K band](#a-model-release-in-the-title-beat-every-formula-title-115k-against-a-16k-77k-band) | Newsjacking is the spike, formula is the floor. One observation. |
| **Descriptions** | |
| [A 49,200 subscriber channel with zero-character descriptions gets 43-146 views a stream](#a-49200-subscriber-channel-with-zero-character-descriptions-gets-43-146-views-a-stream) | Carlo2Million. Subscribers are not what is holding live views down. |
| [Our description is BridgeMind's template with the names changed](#our-description-is-bridgeminds-template-with-the-names-changed) | Same GRIND RULES line, same headings, same block order. Know this before "optimising" it. |
| [The description is 21 blocks, 1,506 characters fixed and 1,247 written fresh](#the-description-is-21-blocks-1506-characters-fixed-and-1247-written-fresh) | The shape of the working description, block by block, and which parts a generator may touch. |
| **Going live** | |
| [OBS stays the encoder and the agent only drives it over obs-websocket](#obs-stays-the-encoder-and-the-agent-only-drives-it-over-obs-websocket) | Keeping the going-live path deterministic means the worst a bad interpretation can do is fail to start something, neve |
| [Going live takes one word from a human, and everything before it is automatic](#going-live-takes-one-word-from-a-human-and-everything-before-it-is-automatic) | Publishing must never happen because a model misread a sentence. There is no audio input anywhere in this design, no m |
| [The countdown runs on air, so saying the words is publishing](#the-countdown-runs-on-air-so-saying-the-words-is-publishing) | People treat the countdown as pre-stream. It is not: the stream is already published the moment it appears. |
| [Local fanout copies one encode to every platform, so every platform gets the same bitrate](#local-fanout-copies-one-encode-to-every-platform-so-every-platform-gets-the-same-bitrate) | Rejected: a second encode to give YouTube a prettier picture. That is real CPU on a laptop already running a game, and |
| **The machine and where things run** | |
| [The live path runs in a terminal on the Acer and nothing about it is hosted](#the-live-path-runs-in-a-terminal-on-the-acer-and-nothing-about-it-is-hosted) | A GitHub Actions runner is a container in a datacentre. It cannot reach obs-websocket, cannot see the capture card, an |
| [Scheduled work belongs in GitHub Actions, live work never does](#scheduled-work-belongs-in-github-actions-live-work-never-does) | It would not be fine for anything a stream is waiting on, which is the same line as the hosting decision. |
| **The overlay and the task board** | |
| [The task board is for viewers, so it never shows the repo](#the-task-board-is-for-viewers-so-it-never-shows-the-repo) | The moment developer vocabulary appears on it, the board has stopped being for the audience. It also never competes wi |
| [An agent may push to the board only when an issue changes state](#an-agent-may-push-to-the-board-only-when-an-issue-changes-state) | A state change is important by definition, and the rule needs no model in the loop, which is the same argument as the  |
| **Measuring** | |
| [Impressions and CTR are owner-only, so a public watch page cannot measure a title](#impressions-and-ctr-are-owner-only-so-a-public-watch-page-cannot-measure-a-title) | Views are the number everyone quotes and the one that answers nothing. |
| [A live broadcast cannot be split-tested, so the test is sequential and the VOD is the fast lane](#a-live-broadcast-cannot-be-split-tested-so-the-test-is-sequential-and-the-vod-is-the-fast-lane) | Carrying a winner from one platform to another is worth doing and is not evidence of anything. Record it as a transfer |
| [A claim needs five observations, one direction, and a bigger effect than the untouched drift](#a-claim-needs-five-observations-one-direction-and-a-bigger-effect-than-the-untouched-drift) | Without a control, an agent reports that a change caused something the algorithm was doing anyway, and it will be sinc |
| **Platforms** | |
| [The channel is @ZayBuilds-b6o, and @CorpAI is a music channel with no streams on it](#the-channel-is-zaybuilds-b6o-and-corpai-is-a-music-channel-with-no-streams-on-it) | `@CorpAI` publishes copyright-free music. Searching it for streams returns nothing because there are none, not because |
| [Twitch simulcasting rules bind Affiliates and Partners, and this account is neither](#twitch-simulcasting-rules-bind-affiliates-and-partners-and-this-account-is-neither) | Affiliate arrives quietly. The rules switch on without anything visibly changing, and three decisions would be in brea |
| [The first working version is YouTube plus two X accounts, not four platforms](#the-first-working-version-is-youtube-plus-two-x-accounts-not-four-platforms) | Whether X RTMP ingest actually works on either account is UNCONFIRMED and is the most likely thing to knock a platform |
| **Credentials** | |
| [Stream keys may live in this private repo, and what that costs](#stream-keys-may-live-in-this-private-repo-and-what-that-costs) | A stream key lets anyone broadcast as you. Recorded here with its trade-off rather than as a bare rule, because the ne |

---

# Titles

## A day-counter title formula does 16K-77K views on the same channel where off-formula titles do 5.4K-5.9K

**verified:** 2026-09-02, `@bridgemindai/streams` read live, 30 lockups parsed
**where:** choosing a live title for `@ZayBuilds-b6o`

Seven streams titled `Day N - Vibe Coding an App Until I Make $1,000,000 | ARR: $X` landed
16K, 24K, 24K, 26K, 35K, 47K and 77K views. Three titled `Vibe Coding No Talking #27/#28/#29`
landed 5.4K, 5.9K and 5.8K, a cluster 500 views wide. Same channel, same weeks, same
description template, and the only difference is whether the title carried a day number,
the goal and the real current figure. The figure is allowed to fall: theirs went
$253,524 to $188,550 across those seven and the fall is the story.

**Why:** a day counter makes it a series rather than an event, and a real falling number
is a reason to come back. This is observational, someone else's natural experiment, not
one we ran. n is 7 against 3.

## A model release in the title beat every formula title, 115K against a 16K-77K band

**verified:** 2026-09-02, video `PjBgS57Hwtc`, 115,306 views, streamed the day Fable 5.1 dropped
**where:** deciding whether to break formula on a given day

`Vibe Coding With Claude Fable 5.1` carries no day number, no ARR and no goal, and it
outperformed every formula title on that channel. Our own best title also carries
`USING FABLE 5.1`, at 256 views against a 2-36 view baseline. Two channels, same week,
same lever.

**Why:** a model release is a search term with a spike behind it and no competition yet.
n is 1 on each channel. Treat as a lever to reach for on release days, not as a rule.

---

# Descriptions

## A 49,200 subscriber channel with zero-character descriptions gets 43-146 views a stream

**verified:** 2026-09-02, `@carlo2million/streams` and video `kM7-VmKhV1E`, description length 0
**where:** any argument that the description is not worth the effort

Six consecutive streams: 114, 87, 56, 130, 146 and 43 views, every description empty,
every title all-caps and non-specific. That channel has 49,200 subscribers against
BridgeMind's 102,000, so roughly half, and gets roughly 1/230th of the views per stream.

**Why:** it is the free control group for the description question. Subscriber count is
not the constraint on live views in this genre.

## Our description is BridgeMind's template with the names changed

**verified:** 2026-09-02, our video `Q5dJuLvhxTI` against their `GiZwDyv5y_I` and `N54TzB6AiSU`
**where:** before changing anything in the description

Both carry `THE GRIND RULES: Every like on this stream = +1 pushup. You hit the button, I
hit the floor.` word for word, plus `The Journey to $1,000,000`, `Current ARR/MRR`,
`What We're Building Today`, a `Links` block and a `What is X?` block, in that order.
Theirs additionally carries the line `Stop typing. Start shipping.`, a member count
inside the Discord link label, and Twitch and YouTube in the links block.

**Why:** the shape is already the proven one. The question is never "what should the
template be", it is "what do they do inside it that we do not".

## The description is 21 blocks, 1,506 characters fixed and 1,247 written fresh

**verified:** 2026-09-02, video `Q5dJuLvhxTI`, 3,290 characters parsed into 21 blocks
**where:** generating or checking a YouTube description

Blocks are separated by blank lines and that separation is load bearing, because YouTube
collapses the first few lines into the visible fold. Fixed: the grind rules, the four
links in order Corp / Discord / X / YouTube, "What is Corp?", the keyword list and the 30
hashtags. Written fresh every stream: the three leading topic hashtags, the hook, the
paragraph naming that day's work, and the five "What We're Building Today" items. The
keyword list alone is 935 characters, over a quarter of the whole thing.

**Why:** the fixed part gets checked, never written, and every check is deterministic:
links present, in order, resolving, spelled right. The 2026-09-02 copy of this
description lost its three leading hashtags, pasted two links as dead display text, and
still described the previous day's stream.

---

# Going live

## OBS stays the encoder and the agent only drives it over obs-websocket

**verified:** 2026-09-02, decided in the stream agent grill
**where:** the stream agent's going-live path

The agent may switch scenes, set the text of named text sources, and start or stop
the broadcast. It may not touch scene composition, because an agent rearranging the
canvas mid-stream is a nightmare rather than a feature. Encoding is solved to a standard
we will not beat, and owning it means owning every dropped-frame and audio-desync problem
for the life of the project. Rejected: the agent owning the video pipeline.

**Why:** Keeping the going-live path deterministic means the worst a bad interpretation can
do is fail to start something, never break something already running.

## Going live takes one word from a human, and everything before it is automatic

**verified:** 2026-09-02, decided in the stream agent grill
**where:** the go-live sequence

The agent checks upload, verifies every ingest endpoint, validates the stream keys,
sets titles and descriptions, loads the countdown scene and writes the day's goals into
the overlay. Then it stops and briefs: what the title is, what worked yesterday, what is
green. A human says go, it presses the button, and it runs the next ten minutes
unattended.

**Why:** Publishing must never happen because a model misread a sentence. There is no audio
input anywhere in this design, no mic, no wake word, no push to talk.

## The countdown runs on air, so saying the words is publishing

**verified:** 2026-09-02, decided in the stream agent grill
**where:** the starting-soon scene

A starting-soon screen only exists if the broadcast is already live. The sequence is
go live, show the countdown, switch to the main scene at zero. The starting-soon scene is
camera on, mic muted, background music, ten minute countdown.

**Why:** People treat the countdown as pre-stream. It is not: the stream is already
published the moment it appears.

## Local fanout copies one encode to every platform, so every platform gets the same bitrate

**verified:** 2026-09-02, measured 100 down / 65 up on the Acer
**where:** the relay

One encode leaves OBS and a local relay copies that same encoded stream to every
endpoint. Copy, not re-encode, so it costs almost no CPU and the game keeps its frames,
and it costs bandwidth instead: one full copy per platform. Four copies at 6 Mbps is 24
Mbps against 65 up, better than double headroom. Because it copies rather than re-encodes,
the bitrate has to be the lowest ceiling among the platforms.

**Why:** Rejected: a second encode to give YouTube a prettier picture. That is real CPU on a
laptop already running a game, and picture quality is not what is holding growth back.


---

# The machine and where things run

## The live path runs in a terminal on the Acer and nothing about it is hosted

**verified:** 2026-09-02, decided against GitHub Actions in the stream agent grill
**where:** hosting the stream agent

The relay has to sit next to OBS anyway, so hosting adds a moving part rather than
removing one. obs-websocket is a localhost service and reaching it from outside means
exposing the one thing that can start a broadcast. A network hop between "go" and the
button is a new failure mode on the one path that must not fail.

**Why:** A GitHub Actions runner is a container in a datacentre. It cannot reach
obs-websocket, cannot see the capture card, and has no way to press the button.

## Scheduled work belongs in GitHub Actions, live work never does

**verified:** 2026-09-02, repo confirmed private by an anonymous api.github.com 404
**where:** the morning backfill, library-admin runs, the progress feed

These are scheduled, need read-only analytics rather than stream keys, and their
output is files committed to a repo, which is what Actions is for. Scheduled Actions are
best effort and can run late, which is fine for a report read the next morning.

**Why:** It would not be fine for anything a stream is waiting on, which is the same line as
the hosting decision.


---

# The overlay and the task board

## The task board is for viewers, so it never shows the repo

**verified:** 2026-09-02, specified by Zayah in the stream agent grill
**where:** the on-stream task board

It shows a general topic in a few words, what has to be done today, the schedule,
and a percent bar. No file names, no commits, no diffs, no issue ids, no branch names.
Somebody watching should understand what is being worked on without knowing anything
about the codebase.

**Why:** The moment developer vocabulary appears on it, the board has stopped being for the
audience. It also never competes with the two display screens, because the screens are
the stream.

## An agent may push to the board only when an issue changes state

**verified:** 2026-09-02, decided in the stream agent grill
**where:** what agents send to the task board

Started, finished or blocked, and at no other time. "Push if it is important" cannot
be left to each agent to judge, because every agent believes its own work is important and
the result is five hours of noise on camera.

**Why:** A state change is important by definition, and the rule needs no model in the loop,
which is the same argument as the deterministic core.


---

# Measuring

## Impressions and CTR are owner-only, so a public watch page cannot measure a title

**verified:** 2026-09-02, a watch page returns viewCount and nothing else
**where:** any claim about what a title did

A healthy CTR with low views is a reach problem and a low CTR with decent impressions
is a title and thumbnail problem. Those are completely different fixes and view count
alone cannot tell them apart. The agent therefore needs an authenticated YouTube Analytics
connection, approved 2026-09-02, and without it the whole title-tracking half degrades to
counting views.

**Why:** Views are the number everyone quotes and the one that answers nothing.

## A live broadcast cannot be split-tested, so the test is sequential and the VOD is the fast lane

**verified:** 2026-09-02, decided in the stream agent grill
**where:** A/B testing titles and descriptions

One broadcast has one title at one moment, so giving YouTube title A and X title B
measures YouTube against X, not A against B. The real test is across streams, compared
within each platform separately, four independent tests running in parallel off one
schedule. The VOD is where it resolves in days rather than months, because the content is
fixed and the title can change repeatedly against it.

**Why:** Carrying a winner from one platform to another is worth doing and is not evidence of
anything. Record it as a transfer, never as a result.

## A claim needs five observations, one direction, and a bigger effect than the untouched drift

**verified:** 2026-09-02, the bar set for library-admin
**where:** anything an agent wants to write into the library

Five changes of the same class on five different subjects, all moving the same
direction, with the median effect larger than the largest swing over the same window in
the population nobody touched. The third check is the one that does the work, because
untouched subjects drift on their own and are a free control group.

**Why:** Without a control, an agent reports that a change caused something the algorithm was
doing anyway, and it will be sincere about it.


---

# Platforms

## The channel is @ZayBuilds-b6o, and @CorpAI is a music channel with no streams on it

**verified:** 2026-09-02, `@CorpAI` video 0HkeCbFqzJ0 is a 2 minute track with 9 views
**where:** any lookup of the stream channel

Nine streams exist on `@ZayBuilds-b6o`, from 2026-08-27 to 2026-09-02. An earlier
version of the plan named CorpAI as the streaming channel and it is not one.

**Why:** `@CorpAI` publishes copyright-free music. Searching it for streams returns nothing
because there are none, not because YouTube is hiding them.

## Twitch simulcasting rules bind Affiliates and Partners, and this account is neither

**verified:** 2026-09-02, stated by Zayah; the policy text itself is UNCONFIRMED
**where:** creating the Twitch endpoint

The account exists under the `zayahwork@gmail.com` Google login and is not Affiliate
or Partner, so the funnel that cross-links all four platforms is clear to build. The
policy could not be read from this machine because help.twitch.tv is a JavaScript app.
Re-check the day Affiliate is accepted.

**Why:** Affiliate arrives quietly. The rules switch on without anything visibly changing,
and three decisions would be in breach at that moment.

## The first working version is YouTube plus two X accounts, not four platforms

**verified:** 2026-09-02, Twitch and Kick accounts do not exist yet
**where:** planning the relay's outputs

YouTube is set up. Two X accounts both have Premium, so both can go live, which is
two X endpoints rather than one. Twitch has an account but no endpoint yet, and Kick has
neither. Account creation is human work and cannot be done AFK.

**Why:** Whether X RTMP ingest actually works on either account is UNCONFIRMED and is the
most likely thing to knock a platform off the list.


---

# Credentials

## Stream keys may live in this private repo, and what that costs

**verified:** 2026-09-02, approved by Zayah, overriding the earlier no-credentials rule
**where:** where stream keys and OAuth tokens live

The original objection was that the repo is on camera, and that was wrong: the repo
is not displayed on the stream. What survives is that a key committed once stays in git
history so rotating does not remove it, an Actions log can print a secret it was handed,
and anyone given repo access later is given the keys with it. The rejected alternative was
one gitignored file on the Acer with the repo holding only the names.

**Why:** A stream key lets anyone broadcast as you. Recorded here with its trade-off rather
than as a bare rule, because the next agent will otherwise re-litigate it.

