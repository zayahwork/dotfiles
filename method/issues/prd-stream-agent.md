# PRD: the stream agent

> Written in the same session as the grilling. The module list was confirmed by Zayah
> on 2026-09-02 before this document existed. Sections that the grilling did not settle
> are named under **Open**, not filled in.

**Status:** modules-confirmed
**Grilled:** 2026-09-02
**Owner:** Zayah
**Grill record:** `stream-agent.md` at the repo root, 40 decisions
**Library:** `library/stream/`, eight subtopics

---

## Problem

Going live is currently a manual sequence that costs an hour and gets things wrong in
public. On 2026-09-02 the description from the best-performing stream was copied by hand
onto the next one and broke three ways at once: the three leading topic hashtags vanished,
the Discord and YouTube links pasted as dead display text rather than URLs, and the body
still promised a from-scratch WSL2 install on a stream titled "Building on 4 hours of
sleep." All three are checks, none are judgement.

Only one platform is set up. Multistreaming today means a paid service or a manual
per-platform setup nobody wants to think about again.

And nothing is recorded. Nine streams exist on `@ZayBuilds-b6o` and the only way to
compare them is to open nine pages by hand, which is how the plan spent its first session
written against the wrong channel entirely.

## Solution

One sentence in a terminal takes the stream live on every platform at once, with titles
and descriptions written natively for each, a countdown on air, and health watched
throughout. One sentence stops it and returns the day's real numbers. Everything is
recorded so the next title is a choice rather than a guess, and nothing is ever claimed
about cause until the record can carry it.

## User stories

- As Zayah, I can type one sentence and the agent preflights everything, briefs me on
  what the title is and what is green, and waits. **Nothing publishes until I say go.**
- As Zayah, I can say go and the broadcast starts, the countdown runs on air, and the
  main scene arrives at zero without me touching anything.
- As Zayah, I can watch the terminal mid-stream and see upload health, dropped frames,
  and which platforms are still connected.
- As Zayah, I can type one sentence to stop and get the day's real numbers immediately,
  plus what we are trying next time.
- As Zayah, I can open a page the next morning and find yesterday's numbers backfilled
  with impressions, CTR and retention.
- As a viewer, I can look at the overlay and understand what is being built today and
  how far along it is, without knowing anything about the codebase.
- As any agent, I can look up one stream fact from `library/stream/` in two short reads
  rather than reading a 700-line plan.

## Purpose modules, confirmed 2026-09-02

| Layer | Module | New or changed | Interface, in one line |
| --- | --- | --- | --- |
| Storage | `secrets` | NEW | Reads stream keys and tokens by name; refuses to start and names what is missing |
| Storage | `config` | NEW | Written by first-run discovery: real OBS scene and source names, endpoints, bitrate ceiling |
| Storage | `dataset` | NEW | Append-only rows: streams, per-platform results, VOD changes, admin verdicts |
| Adapter | `obs` | NEW | Switch scene, set a named text source, start and stop the broadcast. Nothing else |
| Adapter | `relay` | NEW | One encoded input, N outputs, copy not re-encode; reports per-output state |
| Adapter | `youtube` | NEW | `@ZayBuilds-b6o`, login `zayahnelson97@gmail.com`. Set title and description, read impressions, CTR, retention, list VODs |
| Adapter | `x` | NEW | `@CorppAI` (`zayahwork@`) and `@ZayahNelson0` (`zayahwork1@`), both Premium. **Blocked: ingest UNCONFIRMED, neither has gone live** |
| Adapter | `twitch` | NEW | Login `zayahwork@gmail.com`, not Affiliate. **Blocked: account exists, no endpoint** |
| Adapter | `kick` | NEW | Login `zayahwork@gmail.com`. **Blocked: account exists, unconfigured, no endpoint** |
| Service | `metadata` | NEW | One source in, one native title and description per platform out, deterministically |
| Service | `golive` | NEW | Preflight everything, brief the human, press the button on one word |
| Service | `health` | NEW | Upload before, dropped frames and per-platform connection during |
| Service | `experiment` | NEW | Holds one variable per stream, records the commitment, checks it was run |
| Service | `report` | NEW | Numbers at stop, backfilled numbers the next morning |
| Wiring | `command` | NEW | The agent in the terminal. The only place a model is in the loop |
| Wiring | `backfill` | NEW | Scheduled job, read-only analytics, commits its output |
| Wiring | `library-admin` | **exists** | The adversarial gate on every library write. Built 2026-09-02 |
| Surface | `brief` | NEW | The pre-go-live briefing in the terminal |
| Surface | `board` | NEW | Overlay task board. A browser source reading a local file. Never shows the repo |
| Service | `chat` | NEW | Reads every platform's chat, merges into one feed tagged by platform. Read only, never writes |
| Surface | `page` | NEW | The post-stream report, as a lavish artifact |

## The journey

Each phase is one vertical strip down through the layers above. Each ends with something
a person can run and look at, and then CLEAR: the next phase starts in a fresh session
that reads this PRD and the board, not this session's memory.

| Phase | The strip, and what a person looks at when it is done | Layers touched | Blocked by |
| --- | --- | --- | --- |
| **P1** Discovery and refusal | Run it cold. It connects to obs-websocket, lists the real scenes and sources, writes `config`, and if a credential is missing it names exactly which and refuses to start. **Look at:** the written config file, and the refusal message with one key removed. | Storage, Adapter | nothing |
| **P2** One platform, one word | Preflight, brief, wait. On "go" the YouTube broadcast starts, the countdown scene shows on air, the main scene arrives at zero, and one sentence stops it. **Look at:** a real stream that happened, and the terminal brief that preceded it. | Storage, Adapter, Service, Wiring, Surface | P1 |
| **P3** The description generator | One source in, YouTube's 21-block description out. Fixed blocks reproduced exactly, per-stream slots filled, four links present in order and resolving, title spell-checked. **Look at:** generated output diffed against the 3,290-character reference from `Q5dJuLvhxTI`. | Storage, Service | P1 |
| **P4** Health on air | Real upload measured before go-live, dropped frames and per-platform connection state watched during, both spoken in the terminal. **Look at:** the live health line during a real stream, and what it says when an endpoint is pulled. | Adapter, Service, Surface | P2 |
| **P5** The task board | A browser source reading a local file: topic, today's tasks, the schedule, a percent bar. Agents push on issue state change only. **Look at:** the board on the canvas during a stream. | Storage, Wiring, Surface | P1 |
| **P6** Recording and the stop report | Every stream writes its rows. On stop, the day's real numbers in the terminal, plus what we are trying next time. **Look at:** the terminal report, and the rows it came from. | Storage, Service, Surface | P2 |
| **P7** Authenticated analytics | Owner-view YouTube Analytics connected. A scheduled job backfills impressions, CTR, retention and subs the next morning and updates the page. **Look at:** yesterday's page getting more true overnight. | Adapter, Service, Wiring, Surface | P6 |
| **P8** The experiment loop | One variable per stream, the commitment written down, checked next stream that it was actually run. Claims go to `library-admin`, which mostly rejects them. **Look at:** a rejected claim in the dataset with its reason. | Storage, Service, Wiring | P7 |
| **P9** Multi-output relay | One encode, two outputs, copy not re-encode, per-output connection state. **Look at:** two endpoints live off one encode, and the CPU cost of doing it. | Adapter, Service | P4, and the X ingest test (human) |
| **P10** The remaining platforms | Twitch and Kick endpoints, and per-platform native metadata for all four. **Look at:** four platforms live at once from one sentence. | Adapter, Service | P9, and account setup (human) |
| **P11** Chat, merged and isolated | One feed showing everyone chatting and which platform they are on, read only. YouTube first, then each platform as its endpoint lands. **Look at:** the merged feed on the canvas during a stream, and the stream continuing normally with the chat process killed. | Adapter, Service, Surface | P2 |

P3 and P5 do not block on P2 and can be worked in parallel with it. P6, P7 and P8 are a
chain. P9 and P10 are gated on humans, not on code.

## Implementation decisions

Decisions carry the date they were made in the grilling. Full reasoning is in
`stream-agent.md`; this is the one-line form.

- **The agent does not own the video.** OBS stays the encoder and the compositor, driven
  over obs-websocket. 2026-09-02. Encoding is solved to a standard we will not beat.
- **The agent never touches scene composition.** It may switch scenes, set named text
  sources, and start or stop the broadcast. Nothing else. 2026-09-02.
- **Local fanout, copy not re-encode.** One encode leaves OBS, the relay copies it to
  every endpoint. Costs bandwidth instead of CPU: four copies at 6 Mbps is 24 Mbps
  against 65 up measured on the Acer. 2026-09-02.
- **One bitrate for all platforms**, the lowest ceiling among them, because the relay
  copies. 2026-09-02.
- **First-run discovery, never guessing.** The agent lists the real scenes and sources
  and writes what it found. It never assumes a name. 2026-09-02.
- **The countdown runs on air.** Go live, show the countdown, main scene at zero. Saying
  the words is publishing. 2026-09-02.
- **Going live takes one word from a human.** Everything before it is automatic;
  publishing never happens because a model misread a sentence. 2026-09-02.
- **No audio input, ever.** No mic, no wake word, no push to talk. 2026-09-02.
- **The agent never writes into any platform chat.** Read only, all four. 2026-09-02.
- **Every platform gets native metadata.** One source, N outputs. YouTube takes a long
  body, X a post, Twitch and Kick a short title. 2026-09-02.
- **The title carries the number.** A day counter, the goal, and the real current figure,
  which is allowed to fall. Adopted from evidence: on `@bridgemindai` seven formula
  titles did 16K to 77K and three off-formula titles did 5.4K to 5.9K in the same weeks.
- **The description is optimised deterministically.** Links present, in order, correct
  format, spell-checked. A checklist, not a statistics problem, so it works at n=1.
- **The live A/B is sequential, not simultaneous.** One broadcast has one title, so the
  test is across streams, compared within each platform separately. 2026-09-02.
- **The VOD is the fast lane**, and the agent runs it unsupervised. Fixed content, so one
  variable can change at a time against something that is not moving. 2026-09-02.
- **Track everything.** The dataset is the complete append-only record including every
  rejected claim and its reason. `library/` is the earned subset. 2026-09-02.
- **`library-admin` gates every library write.** Its job is to refute, its default verdict
  is reject, and it closes after answering. 2026-09-02.
- **The live path runs on the Acer.** An Actions runner cannot reach obs-websocket or see
  the capture card. Scheduled and analytics work runs in Actions. 2026-09-02.
- **The task board never shows the repo**, and agents push to it only on an issue state
  change. 2026-09-02.
- **Chat runs always, and is isolated from the go-live path.** Zayah, 2026-09-02: it
  should always be working. It is, and it is also never a reason a stream fails to start.
  It runs as its own process, its failure is invisible to `golive`, and the broadcast
  does not check on it. Read only on all four platforms.
- **Accounts, confirmed 2026-09-02.** YouTube `@ZayBuilds-b6o` under
  `zayahnelson97@gmail.com`. X is `@CorppAI` under `zayahwork@gmail.com` and `@ZayahNelson0` under `zayahwork1@gmail.com`.
  Twitch and Kick both under `zayahwork@gmail.com`. All four accounts exist; what does
  not exist is endpoints.

## Testing decisions

The feedback loop per phase, and what a passing run prints.

| Phase | The loop | A pass looks like |
| --- | --- | --- |
| P1 | Run against a real OBS with a known scene set, then again with one credential removed | The written config names the real scenes; the second run exits non-zero naming the missing key |
| P2 | One real broadcast to YouTube, unlisted | The stream exists, the countdown showed, the main scene arrived at zero, and the terminal brief preceded the button |
| P3 | Generate against the captured reference and diff | Fixed blocks byte-identical to `Q5dJuLvhxTI`, four links resolving, zero spelling errors in the title |
| P4 | Pull an endpoint mid-stream | The terminal names which endpoint dropped, within seconds, without stopping the others |
| P5 | Move an issue's state while the board is on the canvas | The board changes; nothing that looks like a file path, commit or issue id ever appears on it |
| P6 | Stop a real stream | The terminal prints the day's numbers, and the rows behind them exist in the dataset |
| P7 | Run the backfill the morning after a real stream | Impressions, CTR and retention appear where only views were, and the page updates |
| P8 | Feed `library-admin` a claim at n=3 | Verdict REJECT, reason recorded in the dataset, nothing written to `library/` |
| P9 | Two endpoints from one encode | Both live, CPU measured before and after, frame rate of the game unchanged |
| P10 | Four endpoints from one sentence | All four live, each with its own native title and description |
| P11 | Kill the chat process mid-stream | The merged feed stops; the broadcast, the overlay and the health line carry on unaffected |

The regression that matters most is P3's: the failure this whole project exists to stop
is a broken description going out, and that is the one test that catches it.

## Out of scope

- **A second encode for a prettier YouTube feed.** Rejected 2026-09-02: real CPU on a
  laptop already running a game, and picture quality is not what is holding growth back.
- **The agent owning encoding or composition.** Rejected: owning it means owning every
  dropped-frame and audio-desync problem for the life of the project.
- **Writing into platform chat.** Rejected: needs a bot account per platform with its own
  rules, and it turns commit messages into public broadcasts.
- **Audio input of any kind.** Rejected outright.
- **Writing into chat.** Reading is in scope (P11). Writing is rejected: it needs a bot
  account per platform with its own rules about automated posting.
- **Thumbnail generation.** Tracking thumbnails is in scope later; making them is not.
- **Any claim about what causes what**, until five observations of the same class agree
  and beat the drift in the untouched population.
- **Clips and VOD editing.** A different project entirely.

## Endpoint setup, the human half

**No agent can do this part.** Every step needs a logged-in browser session, and the
library entry on headless Edge says why that line is not crossed: reaching a page behind
the user's own login needs their real browser profile, which puts any secret on that page
into the session transcript. A stream key is exactly such a secret.

So this section exists to make the human half as short as possible: what to click, in
what order, and where each value goes. **The agent's half is already done: the key names
below are fixed, so pasting a value is the whole remaining step.**

### What `secrets` will look for

Fixed names. `secrets` refuses to start and names the missing one, so a typo here is
loud rather than silent.

| Key | Where it comes from | Needed for |
| --- | --- | --- |
| `YOUTUBE_STREAM_KEY` | YouTube Studio, Go Live, Stream settings | P2 |
| `YOUTUBE_OAUTH_CLIENT_ID` | Google Cloud console, OAuth client | P7 |
| `YOUTUBE_OAUTH_CLIENT_SECRET` | same | P7 |
| `YOUTUBE_OAUTH_REFRESH_TOKEN` | the one-time consent flow, run once by hand | P7 |
| `X_STREAM_KEY_MAIN` | X Media Studio, Producer | P9 |
| `X_STREAM_KEY_ALT` | same, second account | P9 |
| `TWITCH_STREAM_KEY` | Twitch Creator Dashboard, Settings, Stream | P10 |
| `KICK_STREAM_KEY` | Kick Creator Dashboard, Stream settings | P10 |

Each platform also gives an **ingest URL** alongside the key. Both are needed. Name them
`<PLATFORM>_INGEST_URL` with the same suffixes.

### The order to do them in

**1. YouTube first, and only YouTube, until P2 passes.** It is the one platform already
working, so it is the one that proves the whole path. Copy the stream key from YouTube
Studio into `YOUTUBE_STREAM_KEY` and stop there. The OAuth values are not needed until
P7 and are a separate, longer job.

**2. X second, and as a test rather than a setup.** Before pulling any key, answer the
open question: go live once from either account, however badly, and see whether the
option exists at all. **If X has no RTMP ingest for a Premium account, three phases
change shape**, so this is ten minutes that could save a lot of design.

**3. Twitch and Kick last.** Both accounts exist under `zayahwork@gmail.com` and neither
has an endpoint. Neither blocks anything before P10.

### What is still needed from Zayah

Both X handles are known: `@CorppAI` and `@ZayahNelson0`, given 2026-09-02. **The Twitch
and Kick handles are still not written down anywhere**, and the agent needs them for the
links block, the funnel in decision 31, and the per-platform metadata in P10.

The links block also grows a fifth line, because decision 38 gives the second X account
its own identity rather than mirroring the first. Its exact wording waits on the framing
question.


## Open, and who can close it

Named to the only person who can close them. **Not guessed closed.**

| Question | Who | Why it blocks |
| --- | --- | --- |
| Where the merged chat feed sits on the canvas | **Zayah** | Blocks P11's surface. The grill notes the top right slot, which currently holds "Current stack" |
| Does X RTMP ingest actually work? Neither account has ever gone live. | **Zayah**, one throwaway broadcast | Blocks P9 and the `x` module. Most likely thing to knock a platform off the list |
| What does "two framings" mean: same picture with different words, a vertical cut, or two compositions? | **Zayah** | Decides whether P9 costs nothing or costs a second encoder. Recommendation on the table: same picture, different words |
| Does the board replace "Current Goals" on the canvas? | **Zayah** | Blocks P5. The canvas has no free slot |
| What does the percent bar measure? | **Zayah** | Blocks P5. Recommendation: issues inside the current phase, with a `Phase 3 of 7` label |
| What feeds the board? | **Zayah** | Blocks P5. Recommendation: `issues/BOARD.md`, because it updates as a side effect of the work |
| The real character limits for YouTube, X, Twitch and Kick | anyone, by reading | Blocks P10's metadata. To be read, never remembered |
| Twitch and Kick endpoints: profile, customisation, stream key pulled | **Zayah**, at a keyboard | Blocks P10. Both accounts exist under `zayahwork@gmail.com`; neither has a key. Cannot be done AFK |
| YouTube Analytics OAuth connection | **Zayah** | Blocks P7. Approved 2026-09-02, not yet done |

---

## When this ships

Delete this file. The grill record and the `library/stream/` subjects are what survive.
