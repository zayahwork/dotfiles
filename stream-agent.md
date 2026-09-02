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

21. **Every platform gets its own title and description, written native to it.** Not one
    string reused four times. YouTube takes a long body, X takes a post, Twitch and Kick
    take a short title and no long description. The generator has one source and four
    outputs. Decided 2026-09-02 once it became clear the platforms do not share a shape.

22. **The agent gets an authenticated YouTube Analytics connection**, owner view, so it
    reads impressions, CTR and retention rather than the public view count. Approved by
    Zayah 2026-09-02. Without it decision 14 is unbuildable, because a public watch page
    gives views and nothing else. Setup is human work and has not been done.

23. **The live A/B is sequential, not simultaneous, and runs on all four platforms at
    once.** One broadcast cannot show two titles, so the test is across streams: this
    week's title style against last week's, compared within each platform separately.
    Four platforms means four independent tests running in parallel off the same
    schedule, which is what makes "see what works where" real rather than a comparison
    of four incomparable audiences.

24. **The VOD is the fast lane.** After the stream the recording has fixed content, so
    the title, description and later the thumbnail can be changed repeatedly against
    something that is not moving underneath. That is the only test that resolves in days
    rather than months, and it is where the agent is allowed to iterate.

25. **The title carries the number.** BridgeMind's formula titles do 16K to 77K and
    their off-formula titles do 5.4K to 5.9K on the same channel in the same weeks. The
    formula is a day counter, the goal, and the real current figure, and the figure is
    allowed to go down. Adopted from evidence, not taste.

26. **The agent runs the VOD sandbox unsupervised.** No approval per change. It picks
    what to try on a published VOD, tries it, and keeps going. Decided by Zayah
    2026-09-02, after the narrower fence was offered and turned down: the point is to
    let the agent learn, and an agent that stops to ask cannot run enough experiments to
    learn anything.

    Three things ride along with that, and none of them are fences on what it may try.
    They are what makes the trying mean something. It records the previous value of
    anything it changes, because a change it cannot undo is a change it cannot measure.
    It moves one variable at a time, which is decision 15 and was already true. And the
    sandbox is the VOD, never the live broadcast, which decision 7 already protects.

27. **The bar for writing a library entry is a number, not a feeling.** The agent will
    be generating a large volume of small results, and decision 13 says it stays silent
    on causation until the history can carry it. "Can carry it" needs a definition or the
    library fills with confident nonsense. See "The learning loop" below.

28. **The library gets a `stream.md` topic, with Titles and Descriptions as named
    subject groups inside it.** Written 2026-09-02. A lookup stays at three short reads:
    the index row, the contents block, the one subject. When a subject gets fat it
    splits into another subject, and when a topic gets fat it splits into another topic.
    Growth is handled by structure, never by letting one file sprawl and never by
    writing less down.

29. **Everything is tracked. Literally everything.** Nothing the agent does or measures
    is dropped, because what is not written is lost and there is no way to see progress
    without it. The dataset is the complete append-only record and it is expected to get
    enormous. `library/` is the earned subset, and being in one has nothing to do with
    being in the other. A claim the library admin rejects is still written down, in the
    dataset, with the reason.

30. **A library admin subagent gates every new library entry.** The stream agent never
    writes to `library/` directly. It proposes, the admin tests, the admin writes or
    refuses, and then the admin closes. Its job is to refute, not to approve, and its
    default verdict is reject. Full outline below under "The library admin". Requested
    by Zayah 2026-09-02 to stop confident nonsense at machine speed.

31. **The four platforms funnel into each other.** Every description carries the links
    to the other three, so every platform feeds the others rather than four audiences
    sitting in separate rooms. BridgeMind already does exactly this: their links block
    carries YouTube, Twitch, X and a Discord labelled with its member count. Twitch's simulcasting and
    off-platform-linking rules bind Affiliates and Partners; the account here is neither,
    so this is clear to build. See decision 34 for the threshold that would change it.

32. **A task board on the overlay, and it never shows the repo.** Viewers see a
    general topic, what has to be done today, and what the schedule looks like. That is
    all. No file names, no commits, no diffs, no issue ids. Somebody watching should
    understand what is being worked on without knowing anything about the codebase.

    **It never competes with the display screens.** The two screens are the stream. The
    board sits out of their way, and if there is ever a question between more board and
    more screen, the screen wins. It stays small enough that it never earns a scrollbar.

    **A person places it in the scene once**, because decision 2 says the agent never
    touches scene composition and that does not get an exception for its own feature.
    The agent only ever writes the file the browser source reads.

33. **Every library subject carries two tiers.** Tier one is what the admin passed. Tier
    two is what it rejected, kept with the reason and the numbers so far, because a claim
    rejected at n=3 is a claim at n=3 and not a lie. An agent reads tier one, and only
    drops to tier two if tier one did not answer the question. This is the same bargain
    as the three-read index: nothing is thrown away, and the cheap read stays cheap.

34. **Twitch is not an exclusivity problem today.** The account exists, under the
    `zayahwork@gmail.com` Google login, and it is neither Affiliate nor Partner. The
    simulcasting and off-platform-linking rules bind Affiliates and Partners, so decision
    31's funnel is clear to build. **Re-check this the day Affiliate is accepted**, which
    is a threshold that arrives quietly and would silently put decisions 3, 21 and 31 in
    breach.

35. **Stream keys may live in the private repo.** Approved by Zayah 2026-09-02,
    overriding decision 19. The objection first raised against it was that the repo is
    on camera, and that was wrong: Zayah corrected it the same day, the repo is not
    displayed on the stream. What survives the correction is smaller and worth one line
    anyway. A key committed once is in git history permanently, so rotating does not
    remove it; an Actions log can print a secret it was handed; and anyone given access
    to the repo later is given the keys with it. The rejected alternative was one
    gitignored file on the Acer with the repo holding only the names.

36. **Agents push to the board, and only on a state change.** As an agent works it
    sends the board an item, but "only if it is important" cannot be left to each agent
    to judge, or every agent decides its own work is important and the board becomes
    noise on camera. The deterministic version: an agent may push when an issue changes
    state, started, finished or blocked, and at no other time. A state change is
    important by definition and everything else is chatter.

37. **A percent bar next to each task, driven by phases and issues.** Viewers see how
    far along the work is rather than just what it is called. The number comes from the
    board, not from an agent's opinion of its own progress.

    Open detail, and the recommendation is in the next section: phases alone move the
    bar in big jumps and can leave it frozen for hours of a five hour stream, which
    reads as nothing happening. Issues inside the current phase move it several times a
    stream.


38. **The two X accounts get two framings, not one broadcast mirrored.** Decided by
    Zayah 2026-09-02: two framings grow both accounts, and both funnel into everything
    else, so the distribution compounds instead of one account carrying the other.

    **This collides with decision 3 and the collision is real.** Decision 3 buys its
    cheapness by copying one encode rather than re-encoding. Two framings are two
    different pictures, and two pictures cannot come out of one encode. That is a second
    encoder running on a laptop that is already running a game, which is the exact cost
    decision 3 rejected when it turned down a prettier YouTube feed.

    So "framing" has to be pinned down before the relay is designed, and there are three
    versions of it at three very different prices. See "Two framings, three meanings"
    below. **Unresolved.**

39. **Neither X account has ever gone live.** Zayah, 2026-09-02. Both have Premium and
    both can be set up on request. This does not confirm that X RTMP ingest works, it
    confirms that nobody has tried, so the question stays UNCONFIRMED and stays the most
    likely thing to knock a platform off the list. The cheap test is one throwaway
    broadcast to one account before any of this is built around it.

40. **The Kick account exists**, created 2026-09-02 under the `zayahwork@gmail.com`
    login. Not configured, no profile, no stream key pulled. Configuring it is work at a
    keyboard on kick.com and cannot be done from here.

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

## The task board

**What it shows.** A general topic in a few words. What has to be done today. What the
schedule looks like, so viewers know what is coming and when. A percent bar next to each
task. That is the whole thing.

**What it never shows.** The repo. No file names, no commits, no diffs, no issue ids, no
branch names. Somebody watching should understand what is being worked on without
knowing anything about the codebase, and the moment developer vocabulary appears on it
the board has stopped being for the audience.

**Where it goes, and this is a real constraint.** The canvas is already full: main screen
top left and large, second screen bottom right, facecam bottom left, "Current Goals" top
centre, "Current stack" top right. There is no empty slot to drop a board into, and the
rule is that it never competes with the two display screens because the screens are the
stream.

Recommendation: **the board replaces "Current Goals" rather than joining it.** They are
the same idea built twice, one hand-written and one live, and the live one wins. That
frees the top centre slot at full width without touching either screen, and it removes a
text source that has to be remembered rather than updating itself.

**What feeds it.** Agents push, and only on an issue state change: started, finished, or
blocked. Nothing else, ever. "Push if it is important" cannot be left to each agent to
judge, because every agent believes its own work is important, and the result is noise on
camera during a five hour stream. A state change is important by definition and the rule
needs no model in the loop, which is the same argument as the deterministic core.

**What the percent bar measures.** Open, and the recommendation is two numbers rather
than one:

- **The bar itself is issues finished inside the current phase.** It moves several times
  in a stream, which is what makes it worth watching.
- **A small label next to it reads `Phase 3 of 7`.** That carries the shape of the whole
  project without needing a second bar.

Phases alone would move the bar in big jumps and leave it frozen for hours of a five hour
stream, which reads to a viewer as nothing happening, which is the opposite of the point.


## The channel

- **The streams live on `@ZayBuilds-b6o`**, not on `@CorpAI`. `@CorpAI` is a
  copyright-free music channel: its video `0HkeCbFqzJ0` is a 2 minute track with 9
  views. An earlier note in this file called CorpAI the streaming channel. It is not.
- **Nine streams exist**, 2026-08-27 to 2026-09-02, and all nine were read on 2026-09-02
  straight off the watch pages.

| Published | Views | Length | Desc | Title |
| --- | --- | --- | --- | --- |
| 2026-08-27 | 7 | 1:07 | 91 | Day 1 - 19 Year old tries to make 1,000,000 ARR |
| 2026-08-31 | 29 | 2:28 | 87 | Day 2 - Solo founder road to 1,000,000 ARR - Current: 100,800 ARR |
| 2026-08-31 | 12 | 0:22 | 87 | Day 2 - Solo founder road to 1,000,000 ARR - Current: 100,800 ARR |
| 2026-09-01 | 256 | 5:03 | 3290 | 🔴 Building an L8 Agentic Dev Environment From Scratch (I've Never Done This)  USING FABLE 5.1 |
| 2026-09-01 | 36 | 2:44 | 113 | L8 Agentic engieering switch over - USING FABLE 5.1 |
| 2026-09-01 | 33 | 3:57 | 53 | Day 2 – SOLO Startup Until I Make $1,000,000 \| ARR: $100,800 |
| 2026-09-01 | 11 | 0:20 | 87 | Day 2 - Solo founder road to 1,000,000 ARR - Current: 100,800 ARR |
| 2026-09-02 | 5 | 0:00 | 3209 | 🔴 Building on 4 hours of sleep USING FABLE 5.1 |
| 2026-09-02 | 2 | 0:02 | 113 | 🔴 Building on 4 hours of sleep USING FABLE 5.1 |

Read this as a record, not a finding. There is one stream with a long description and it
is also the longest stream and the one with the best title, so three things moved at
once and n is 1. Decision 13 applies to our own data too: log it now, say nothing about
cause until the history can carry it. What is worth noticing without claiming anything
is that eight of the nine descriptions are 53 to 113 characters, and the ninth is 3,290.

## The working description

Pulled 2026-09-02 from video `Q5dJuLvhxTI`, the 2026-09-01 stream, 256 views, 5h03m.
3,290 characters. This is the asset. Anything generated has to reproduce this shape.

```
#AgenticEngineering #DevEnvironment #ClaudeCode

🔴 BUILDING AN L8 AGENTIC DEV ENVIRONMENT FROM SCRATCH. Zero to keyboard-only, live. No mouse. No IDE. Just a terminal and agents. We are ripping out the entire setup and rebuilding it the way principal engineers actually work — and I have never done this before.

Today we go from a blank Windows box to a full Linux dev environment running inside WSL2. Ubuntu, zsh, fzf, Starship, Neovim, and Claude Code wired together into one keyboard-driven loop. Every shortcut learned live. Every mistake on camera. Most devs never leave VS Code. Today we find out what's on the other side.

THE GRIND RULES: Every like on this stream = +1 pushup. You hit the button, I hit the floor.

The Journey to $1,000,000

Current MRR: $8,400/month

What We're Building Today

WSL2 + Ubuntu 26.04 From Zero — Linux running inside Windows. Full install, live, from a completely fresh terminal.

The Keyboard-Only Workflow — 60% keyboard, no arrow keys, no F-row. Every navigation shortcut rebuilt around Ctrl bindings. Live quizzes as we learn them.

zsh + Starship + fzf — Ghost-text autosuggestions, syntax highlighting before you hit Enter, and fuzzy search that kills typing file paths forever.

Reproducible Dotfiles — One repo, one command, any machine ends up identical. The core thesis of the whole setup.

Claude Code At Full Power — Global AGENTS.md, project memory, and agent ergonomics inside a real terminal workflow.

Links

Corp — https://corpsystems.net

Discord — https://discord.gg/EfqrAdSa3

X (Twitter) — https://x.com/CorppAI

YouTube — https://www.youtube.com/@ZayBuilds-b6o

What is Corp?

Corp is an AI automation agency for small businesses — the face of AI for the business world. We take the systems that big companies pay millions for and put them in the hands of the shops, studios, and service businesses that actually run the economy. Automation, agents, and AI workflows built for people who don't have an engineering team.

Keywords: AI automation agency, AI for small business, small business automation, AI agency, business automation, AI consultant, AI workflows, agentic engineering, agentic dev environment, dev environment from scratch, terminal setup, terminal workflow, WSL2, WSL2 setup, WSL2 Ubuntu, Ubuntu 26.04, Windows Subsystem for Linux, zsh, zsh setup, zsh autosuggestions, Starship prompt, fzf, ripgrep, Neovim, Neovim config, tmux, WezTerm, dotfiles, dotfiles repo, reproducible dev environment, Nix, home-manager, keyboard only workflow, 60% keyboard, keyboard shortcuts, terminal keybinds, no mouse workflow, Claude Code, Claude Code setup, Claude Fable 5.1, AGENTS.md, CLAUDE.md, agent memory, agent skills, L8 principal engineer, principal engineer workflow, developer productivity, vibe coding, agentic coding, AI coding tools, build in public, live coding, learn to code, indie hacker, AI startup, Corp, CorppAI, Corp Systems, ZayBuilds

#Corp #CorppAI #ZayBuilds #AIAutomation #AIForSmallBusiness #AIAgency #BusinessAutomation #AgenticEngineering #DevEnvironment #ClaudeCode #ClaudeFable51 #WSL2 #Ubuntu #Linux #Zsh #Neovim #Tmux #Starship #Dotfiles #TerminalSetup #KeyboardOnly #60PercentKeyboard #VibeCoding #DeveloperProductivity #BuildInPublic #LiveCoding #IndieHacker #SaaS #StartupFounder #AgenticAI
```

### Its outline, 21 blocks

Blocks are separated by blank lines and that separation is load bearing, because YouTube
collapses the first few lines into the visible fold and hides everything after it behind
"more".

| # | Chars | Block | Changes? |
| --- | --- | --- | --- |
| 1 | 47 | Three topic hashtags. These are what YouTube renders *above* the title. | per stream |
| 2 | 262 | The hook. All-caps opener behind a red circle, then the promise, then the personal stake. | per stream |
| 3 | 316 | What today actually is, in specifics, ending on a hook line. | per stream |
| 4 | 92 | THE GRIND RULES. The engagement mechanic. | fixed |
| 5-6 | 50 | The Journey to $1,000,000, then Current MRR. | a number |
| 7-12 | 669 | What We're Building Today. Five items, each `Name - one sentence, one sentence`. | per stream |
| 13-17 | 156 | Links. Four, in order: Corp, Discord, X, YouTube. | fixed |
| 18-19 | 355 | What is Corp? | fixed |
| 20 | 935 | Keywords, one comma list. | mostly fixed |
| 21 | 368 | 30 hashtags. | mostly fixed |

Fixed blocks are 1,506 characters of the 3,290. Written-fresh blocks are 1,247. The
keyword list alone is 935, more than a quarter of the whole description.

### What happened to it the next day

The 2026-09-02 stream (`mdZd7NL2fq8`, 5 views) reused this description by copy and
paste, and the copy broke three ways at once:

1. **Block 1 vanished.** The three topic hashtags, the ones that show above the title,
   are simply not in the 09-02 version.
2. **Two links died.** Discord and YouTube pasted as YouTube's rendered display text,
   `/ discord` and `/ @zaybuilds-b6o`, instead of the URLs. Dead text on a live
   video.
3. **The body was never updated.** The 09-02 stream is titled "Building on 4 hours of
   sleep" and its description still promises a from-scratch WSL2 install on a blank
   Windows box.

This is the case for the whole tool, and it is not hypothetical. It happened on
2026-09-02, unassisted, to the best performing description on the channel. A
deterministic generator catches all three, because all three are checks and none of them
are judgement.


## The comparables, read 2026-09-02

Searched YouTube six ways for this genre and pulled the two channels doing the same
thing. Both were read off the live pages, not remembered.

### BridgeMind, `@bridgemindai`, 102K subscribers

**This is where the description template came from.** Their descriptions carry the same
GRIND RULES line word for word, the same "The Journey to $1,000,000", the same "Current
ARR", the same "What We're Building Today", the same Links block, the same "What is X?"
block. Ours is their template with the names changed. That is worth knowing before
"optimising" it, because the shape is already the proven one and the question is what
they do inside it that we do not.

Their last fourteen streams:

| Views | Streamed | Title |
| --- | --- | --- |
| 115K | 18 hours ago | Vibe Coding With Claude Fable 5.1 |
| 26K | 23 hours ago | Day 223 - Vibe Coding an App Until I Make $1,000,000 \| ARR: $188,550 |
| 47K | 2 days ago | Day 222 - Vibe Coding an App Until I Make $1,000,000 \| ARR: $190,186 |
| 35K | 5 days ago | Day 221 - Vibe Coding an App Until I Make $1,000,000 \| ARR: $195,420 |
| 5.8K | 7 days ago | Vibe Coding No Talking #29 |
| 24K | 8 days ago | Day 220 - Vibe Coding an App Until I Make $1,000,000 \| ARR: $199,344 |
| 77K | 12 days ago | Day 219 - Vibe Coding an App Until I Make $1,000,000 \| ARR: $196,200 |
| 47K | 13 days ago | Day 218 - Vibe Coding an App Until I Make $1,000,000 \| ARR: $194,904 |
| 5.9K | 2 weeks ago | Vibe Coding No Talking #28 |
| 25K | 2 weeks ago | Vibe Coding For 10 Hours Straight #1 |
| 24K | 3 weeks ago | Day 217 - Vibe Coding an App Until I Make $1,000,000 \| ARR: $251,759 |
| 16K | 4 weeks ago | Day 216 - Vibe Coding an App Until I Make $1,000,000 \| ARR: $253,524 |
| 5.4K | 4 weeks ago | Vibe Coding No Talking #27 |

**The formula titles land 16K to 77K. The off-formula "No Talking" titles land 5.4K,
5.9K and 5.8K.** Same channel, same weeks, same description template, and the only thing
that changed is whether the title carried the day number, the goal and the live ARR.
Seven against three, and the three cluster inside 500 views of each other. This is
observational, not an experiment we ran, but it is the strongest signal available and it
did not come from n=1.

The one title that beat every formula title is newsjacking: "Vibe Coding With Claude
Fable 5.1", posted the day the model dropped, 115K. Our own best title also carries
"USING FABLE 5.1". Formula is the floor, a model release is the spike.

Things they do in the description that we do not:

- **The real number is in the title**, updated every stream, and it is allowed to go
  down. $253,524 to $188,550 across seven streams. The falling number is the story.
- **A day counter.** Day 216 through 223. It makes the stream a series rather than an
  event, and it is the same argument as a serialised show.
- **Social proof inside a link label:** `Discord (14,600+ Builders)`, not `Discord`.
- **A tagline line** after the GRIND RULES: "Stop typing. Start shipping."
- **Twitch and YouTube in the links block**, because they are actually multistreaming.
- The first two paragraphs are rewritten every single stream to name that day's actual
  work. Day 222 names BridgeMind One, GPT Astra watch, Fable 5.1 watch, Hermes Agent.
  Nothing is recycled.

### Carlo2Million, `@carlo2million`, 49.2K subscribers

The control group, and the more useful of the two.

| Views | Streamed | Title | Desc |
| --- | --- | --- | --- |
| 114 | 7d ago | 🔴 ROAD TO $1M LIVE DAY 33 | 0 chars |
| 87 | 8d ago | 🔴 ROAD TO $1M LIVE DAY 32 | |
| 56 | 10d ago | 🔴 UC SANTA BARBARA STREAM DAY 3 | |
| 130 | 11d ago | 🔴 UC SANTA BARBARA STREAM DAY 2 BACKFLIPS | |
| 146 | 13d ago | 🔴 ROAD TO $1M DAY 28 HAIRCUT | |
| 43 | 2w ago | 🔴 ROAD TO $1M DAY 27 LIVE WORKOUT AND Q&A | |

**49,200 subscribers and 43 to 146 views a stream.** Their descriptions are empty, zero
characters, and their titles are all caps with no number, no promise and no specific.
They have 380 times our subscriber count and roughly four times our views.

Subscribers are not the constraint. The two channels differ by 2x in subscribers and by
roughly 230x in views per stream, and what differs between them is the title formula and
whether a description exists at all.


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

## The learning loop

Zayah, 2026-09-02: "let the agent do what it wants, and learn as it goes, tracking
everything in the library, that is how we get the agents sharper."

Agreed on all of it, with one split that decision 18 already made and that matters more
now that the volume is going up.

**Nothing is dropped, and the two files have different jobs.** What is not written is
lost, so everything the agent does and everything it measures gets written, including
the claims that turn out to be wrong and the reason they were wrong. That is decision 29
and it is not negotiable. What the split is about is which file, because the library's
value is that a lookup costs three short reads and a miss costs one. Put every VOD title
change in it and that contract breaks, and a library nobody can search is a library
nobody reads.

- **The dataset holds all of it.** Every change: which VOD, what field, the old value,
  the new value, the timestamp, the impressions and CTR for a fixed window before and
  after. Every verdict the library admin reaches, including every rejection and its
  reason. Append only, machine written, expected to get enormous. This is the record.
- **`library/` holds the earned subset**, in the library's own format, gated by the
  library admin. Topics and subjects keep it findable as it grows: `stream.md` exists
  now with Titles and Descriptions inside it, and a fat subject splits into another
  subject rather than sprawling.

**The bar for graduating a row set into an entry.** Proposed, and this is the open
question:

1. At least **five** changes of the same class, on five different VODs.
2. All five moving the **same direction**.
3. The median effect **larger than the largest swing seen over the same window on VODs
   the agent did not touch at all.**

Point 3 is the one that does the work. Untouched VODs drift on their own, and they are
sitting right there as a free control group. Without them the agent will confidently
report that a title change caused something the algorithm was doing anyway, which is
exactly the failure decision 13 exists to prevent, arriving through the front door
because we gave the agent autonomy and no bar.


## The library admin

A subagent, spawned per proposed entry, closed the moment it answers. It is the only
thing allowed to write to `library/`. It is adversarial on purpose: **its job is to
refute the claim, and its default verdict is reject.** An approver would rubber stamp,
because the thing it is checking was written by an agent that already believes it.

**What it is handed.** The proposed claim in one sentence. The exact dataset rows that
support it. The topic and subject it would live under. The current contents block of
that topic.

**What it checks, in order, stopping at the first failure.**

1. **Is it already known?** If an entry covers this, the verdict is UPDATE, not WRITE.
   Never a second entry on the same fact, because two entries on one fact is how a
   library stops being trustworthy.
2. **Is n enough?** At least five changes of the same class, on five different VODs.
3. **Do they agree?** All five moving the same direction. Four and one is not four.
4. **Does it beat the control?** The median effect has to be larger than the largest
   swing over the same window on VODs the agent did not touch. Untouched VODs drift on
   their own and are a free control group. This is the check that kills most claims and
   it is the reason the admin exists.
5. **What else moved?** A model release, a clip that travelled, a shorts post, a
   different day of the week. If something else moved in the window, the verdict is
   reject and the reason is the confound.
6. **Is it in the format?** The number in the title, a `verified:` line naming the rows
   that prove it, a `where:`, five sentences or fewer. A true fact in the wrong shape is
   unfindable, so it fails here and comes back rewritten.

**What it emits.** One of WRITE, UPDATE or REJECT, with the reason in one line. On WRITE
or UPDATE it edits the topic file and the contents block and the index row if the
description no longer matches. On REJECT it writes nothing to `library/`.

**Either way the verdict is a dataset row**, including every rejection and its reason.
That is decision 29, and it also stops the same rejected claim being proposed again next
week, and again the week after, forever.

**Then it closes.** It holds no state between runs. Everything it needs to know is in
the dataset and in the library, which is the point of both.


## Two framings, three meanings

Decision 38 says two framings for the two X accounts. What "framing" means decides
whether this costs nothing or costs a second encoder, so it has to be settled first.

**1. Same picture, different words. Free.** One encode, copied to both accounts, but each
account gets its own title, its own description, its own pinned post and its own reply
style. The accounts read as different because the framing around the video differs, not
the video. Costs nothing in CPU, nothing in bandwidth beyond the copy that was already
planned, and it keeps decision 3 exactly as it is.

**2. Same source, different crop. Costs one encode.** One account gets the 16:9 feed, the
other gets a 9:16 vertical cut for X's mobile surface. That is a genuinely different
picture, so it is a second encode and a second scale, on a laptop already running a game
and an OBS composite. Real CPU, and the first thing to suffer is the frame rate of the
thing being streamed.

**3. Two different compositions. Costs one encode and a second scene.** Different layouts,
different overlays, different emphasis. Everything in option 2 plus scene work the agent
is not allowed to do (decision 2), so a person builds and maintains both.

**Recommendation: option 1 now, option 2 later if the numbers ask for it.** It gets the
whole growth argument, two accounts that read as distinct and funnel into each other,
without spending a single frame of the game. And if X vertical turns out to matter, the
measurement to justify option 2 will exist by then, which is the entire point of the
recorder.

**Blocked behind decision 39 either way.** No version of this is worth designing until
one throwaway broadcast proves X RTMP ingest works at all.


## Hosting

Recommendation: **the live path runs in a terminal on the Acer, and nothing about it is
hosted.** Reasons, in order of weight.

1. **The relay has to be local anyway.** Decision 3 puts a local fanout next to OBS so
   one encode is copied rather than re-encoded. A hosted agent still needs that process
   on the Acer, so hosting does not remove a moving part, it adds a second one.
2. **obs-websocket is a localhost service.** Driving it from outside means exposing it,
   or tunnelling to it, which is a new attack surface guarding the thing that can start
   a broadcast as you.
3. **Decision 19 puts the credentials on the Acer**, one file, outside git. Hosting means
   a second copy somewhere else, and stream keys let anyone broadcast as you.
4. **A network hop is a new failure mode on the one path that must not fail.** If the
   agent is remote, an internet blip between "go" and the button is a stream that does
   not start, for a reason that has nothing to do with streaming.
5. **You are sitting at the machine.** The whole interface is one sentence typed into a
   terminal that is already open.

The one piece that is a genuine candidate for hosting is the **next-morning backfill**
from decision 16: impressions, CTR, retention and subs pulled the day after and the
report updated. That runs when the Acer may be off, it touches no live path, and it
needs read-only analytics rather than stream keys. If anything gets hosted, it is that,
and only that.

So: **one process on the Acer for everything live, and a scheduled job for the morning
report, with the door open to that job living elsewhere later.**

### Should the agents just run inside GitHub?

Split, and the line is the same one.

**Not the live path.** A GitHub Actions runner is a fresh container in a datacentre. It
cannot reach obs-websocket on the Acer, it cannot see the capture card, and it has no
way to press the button. Putting the stream keys in GitHub secrets to work around that
means a second copy of credentials that can broadcast as you, which is exactly what
decision 19 refuses.

**Yes for everything that is not live.** The morning backfill from decision 16, the
library admin runs from decision 30, and the progress feed from decision 32 are all a
good fit: they are scheduled, they need read-only analytics rather than stream keys,
their output is files, and files committed to a repo is what Actions is for. The repo is
private, verified 2026-09-02 by an anonymous `api.github.com` request returning 404, so
secrets in it are not sitting in public.

**One caveat.** Scheduled Actions are best effort and can be delayed under load. That is
fine for a report you read the next morning. It would not be fine for anything with a
stream waiting on it, which is another reason the live path stays on the Acer.


## Open, still to grill

Pick up here.

1. **The fixed skeleton of the description vs its per-stream slots.** The asset is
   captured. Zayah wants the title and the description to change every stream to match
   what is actually being built, so the generator needs a frozen part and a
   written-fresh part, and the line between them is not drawn yet.
2. **What links go in it.** Unblocked, all four read off the live video: Corp
   `https://corpsystems.net`, Discord `https://discord.gg/EfqrAdSa3`, X
   `https://x.com/CorppAI`, YouTube `https://www.youtube.com/@ZayBuilds-b6o`. What is
   left is whether that order is deliberate, whether any one of them is non-negotiable,
   and whether the second X account gets a fifth line once it goes live.
2c. **The real character limits** for titles and descriptions on YouTube, X, Twitch and
   Kick. UNCONFIRMED, and they get read rather than remembered before the generator is
   written.

2d. **Where the agent runs.** Terminal on the Acer, or hosted somewhere. Recommendation
   below in "Hosting". Open until Zayah picks.

3. **X live video.** Answered halfway: neither account has ever gone live (decision 39),
   so whether X RTMP ingest works for a Premium account is still UNCONFIRMED and nothing
   should be designed around it. The cheap test is one throwaway broadcast to one
   account. Until that passes, X is a maybe and the first working version is YouTube
   alone.
4. **What "two framings" means for the two X accounts.** Decided in principle
   (decision 38), unresolved in cost. Three readings at three prices, in "Two framings,
   three meanings". Recommendation is option 1, same picture and different words, which
   is free and keeps decision 3 intact.
5. **Kick and Twitch setup.** Both accounts now exist under `zayahwork@gmail.com`.
   Neither is configured: no profile, no stream key pulled, no endpoint. This is
   keyboard work on kick.com and twitch.tv and cannot be done from this machine.
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

Grilled 2026-09-02 in two sessions. The first got ten questions in and ended because the
day did. The second read the real assets instead of talking about them: all nine streams
off `@ZayBuilds-b6o`, the working 3,290-character description off video `Q5dJuLvhxTI`,
and the two comparable channels in the genre. Decisions 21 through 32 came out of it.
`library/web.md` was rewritten, because it claimed a thing was impossible that turned out
to be four lines of Python, and `library/stream.md` was created with Titles and
Descriptions as its first two subjects.

The interview is still open. Next session picks up at open question 1, and the newest
loose end is where the progress panel gets "current projects" from.
