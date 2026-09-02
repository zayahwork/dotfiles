# Stream agent

The stream manager. You open a terminal on the Acer, an agent reads this file, and the
stream goes live on every platform at once. Afterwards it tells you how it went.

**State: grilling, not finished.** Nothing here is built. The decisions below are
settled and should not be relitigated. The open questions below are not, and the next
session picks up at the first one.

---

## The ask, as said (2026-09-02)

- **Multistream.** One go-live pushes to every platform at once. A Restream remake,
  running locally, no subscription.
- **Global chat.** One merged feed showing everyone chatting and which platform they
  are on.
- **Title and thumbnail tracking.** Record what was tried and what happened, so the
  next title is a choice and not a guess.
- **Optimised titles and descriptions** with the links already in them.
- **One sentence to start.** "Hey, let's go live." One to stop. "Okay, let's stop
  stream, give me an overview of how it went and what we're trying next time."
- **Never have to think about multistream setup again.**

---

## The shape

Two layers, and only one of them is allowed to be smart.

**The deterministic core.** A program. Runs the relay, the overlay text, the countdown,
the chat merge, the health checks, the logging. No model in the loop. When you hit go it
goes, the same way every time. This is the script.

**The command layer.** An agent in a terminal reads this file and calls into the core.
This is where "hey, let's go live" gets understood.

The reason for the split: a live stream is unforgiving. Anything a model decides in the
moment can be slow or wrong, and both happen in front of an audience. Keeping the
going-live path deterministic means the worst a bad interpretation does is fail to start
something, never break something already running.

**This repo holds the plan. The Acer runs the thing.** Nothing in the design may assume
this machine, this Nix setup, or this shell.

---

## Decided

1. **The agent does not own the video.** OBS stays the encoder and the compositor. The
   agent drives it over obs-websocket. Encoding is solved to a standard we will not
   beat, and owning it means owning every dropped-frame and audio-desync problem for the
   life of the project.

2. **The agent never touches the scene composition.** The layout exists and works. An
   agent rearranging the canvas mid-stream is a nightmare, not a feature. It may switch
   scenes, set the text of named text sources, and start or stop the broadcast. Nothing
   else.

3. **Local fanout, no paid service.** One encode leaves OBS, a local relay copies that
   same encoded stream to every endpoint. Copy, not re-encode, so it costs almost no CPU
   and the game keeps its frames. Costs bandwidth instead: one full copy per platform.

4. **One bitrate for all platforms.** Because the relay copies rather than re-encodes,
   every platform gets the same bitrate, and it has to be the lowest ceiling among them.
   Rejected: a second encode to give YouTube a prettier picture. That is real CPU on a
   laptop already running a game, and picture quality is not what is holding growth back.

5. **First-run discovery, never guessing.** The agent connects to obs-websocket, lists
   the real scenes and sources, and writes what it found to a config file. It never
   assumes a name. This is what makes "just run it on the Acer" true.

6. **The countdown runs on air.** A starting-soon screen only exists if the broadcast is
   already live. So the sequence is: go live, show the countdown, switch to the main
   scene at zero. Saying the words is publishing.

7. **Going live needs one word from you.** The agent does everything: checks upload,
   verifies every ingest endpoint, validates the stream keys, sets titles and
   descriptions, loads the countdown scene, writes the day's goals into the overlay.
   Then it stops and briefs you: what the title is, what worked yesterday, what is green.
   You say go. It presses the button and runs the ten minutes unattended from there.
   Publishing never happens because a model misread a sentence.

8. **Starting-soon scene:** camera on, mic muted, background music, ten minute countdown.

9. **No audio input, ever.** No mic, no wake word, no push to talk. The agent is a
   terminal. Rejected earlier for false triggers on a live mic; rejected outright here.

10. **The agent never writes into any platform chat.** Read only, all four. Writing needs
    a bot account per platform, each with its own rules about automated posting, and it
    turns your commit messages into public broadcasts. Commits print in the terminal.

11. **Global chat is in scope, read only, phase two.** Not in the same phase as going
    live, because a broken chat websocket must never be a reason the stream does not
    start. Free on every platform in money, expensive in engineering.

12. **Health is tracked live.** Real upload measured before go-live, dropped frames and
    per-platform connection state watched during. If a platform silently drops at minute
    forty you hear it from the agent, not from chat.

13. **The agent is a recorder, not an oracle.** At 36 views a stream you cannot measure
    what titles convert, and a tool that says "titles with a version number do 22% better"
    after ten streams is lying with a straight face. It logs everything now so the history
    exists later, reports the day's real numbers every day, and stays silent on causation
    until there is enough data to say it honestly. It reports how far off that is.

14. **CTR and impressions, not views.** Healthy CTR with low views is a reach problem.
    Low CTR with decent impressions is a title and thumbnail problem. Two completely
    different fixes, and views alone cannot tell them apart.

15. **One variable per stream.** New title style, or new thumbnail, or new start time.
    Never two. The agent proposes one, you approve it, it writes it down as a commitment,
    and next stream it checks you actually ran the experiment you agreed to.

16. **Two reports, not one.** At stop: the live numbers immediately, in the terminal,
    plus what we're trying next time. Next morning: impressions, CTR, retention and subs
    backfilled, and the lavish page updated. Yesterday's page gets more true overnight
    instead of being wrong forever.

17. **The post-stream report is a lavish artifact.** Charts and graphs, what worked and
    what did not, a page you look at rather than a wall of terminal numbers.

18. **The library split.** Per-stream rows are a dataset and live in their own append
    file. A thing that is *learned* goes in `library/` in the library's own format, with
    the number in the title and a `verified:` line. "Streams started at 8am get 3x the
    impressions of 2pm, verified over 30 streams" is a library entry. "Stream 47, 41
    impressions" is a row. Both get written, in different places.

19. **No credentials in this repo.** Stream keys and OAuth tokens let anyone broadcast as
    you. One file on the Acer, outside git, gitignored twice. The repo holds only the
    names of what belongs in it. First-run setup names exactly what is missing and
    refuses to run until it is there.

20. **The description is optimised deterministically.** Links present, in order, correct
    format, nothing missing, no typos. A checklist, not a statistics problem, so it works
    at any sample size. Includes a spell check on the title before it publishes.

---

## The machine

- **Streams from:** the Acer. Windows 11, OBS, capture card already in use and working.
- **Two computers**, not two monitors. The desktop's picture reaches the Acer over the
  capture card. Already set up.
- **Connection:** 100 down, 65 up, measured 2026-09-02. Four copies at 6 Mbps is 24 Mbps,
  so there is better than double headroom. Four-way local fanout is comfortably on.
- **This repo** is built on the WSL machine and consumed on the Acer.

## The overlay, as it exists

From `Screenshot 2026-09-02 080802.png`, the 2026-09-01 stream:

- Main screen top left, large and dominant.
- Second screen bottom right.
- Facecam bottom left.
- "Current Goals" as a text source, top centre. Agent-writable.
- "Current stack" top right, listing the four plans.
- **No chat box in the canvas.** The chat panel in that screenshot is YouTube's own
  replay panel, not part of the layout. The merged feed is a thing to build, and the top
  right slot is where it goes.

## The channel

- **YouTube: CorpAI**, 130 subscribers. The only platform currently set up.
- Reference stream: "L8 Agentic engieering switch over - USING FABLE 5.1", 2:44:01,
  streamed 2026-09-01, 36 views. Note the typo in the real title. This is why the agent
  proofreads.
- The long description on recent live videos is the one that works. **Not yet captured.
  It needs to be pasted into this file before a generator is written.**

## Platforms, actually

This changed late in the grilling and the plan has not caught up with it yet.

- **YouTube** - set up. CorpAI.
- **X** - two accounts, both X Premium, so both can go live. Two X endpoints, not one.
- **Twitch** - **no account.** Has to be created.
- **Kick** - **no account.** Has to be created.

So the first working version is not four platforms. It is YouTube plus two X accounts,
and Twitch and Kick arrive when the accounts do. Account creation is human work and
cannot be done AFK.

---

## Open, still to grill

Pick up here.

1. **The long YouTube description.** Paste the real one in. Nothing gets generated until
   the working asset has been read.
2. **What links go in it**, in what order, and which are non-negotiable.
3. **X live video.** Two Premium accounts, but has either ever actually gone live?
   RTMP ingest on X has historically been gated. UNCONFIRMED, and the most likely thing
   to knock a platform off the list. Verify before designing around it.
4. **Two X accounts at once** - is that one broadcast mirrored to both, or two different
   framings? It changes whether the relay has four outputs or five.
5. **Twitch and Kick account creation** - who does it and when. Blocks their endpoints.
6. **The bitrate ceiling.** X's real limit decides the number every platform gets.
   Verify it, do not trust memory.
7. **What the daily brief says.** "Here's the title, here's what worked yesterday" needs
   a fixed shape, or it will be different every day and unreadable.
8. **Goals in the overlay** - does the agent write them from what you tell it, and where
   do they come from? The board? A prompt at go-live?
9. **The stop command.** Does it end the broadcast on every platform at once, and is
   there a confirmation, given stopping is as irreversible as starting.
10. **VODs and clips.** Anything happen to the recording afterwards, or is that a later
    project entirely.
11. **Where the agent's data lives** on the Acer, and whether the log is committed to
    this repo or kept local.

## Where we stopped

Grilled 2026-09-02, roughly ten questions in, ended because the day did. The interview is
open, not finished, and the next session continues it rather than starting to build.
