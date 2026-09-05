# Going live

The sequence from cold to broadcasting, and what the agent may and may not touch.

## Contents

- [OBS stays the encoder and the agent only drives it over obs-websocket](#obs-stays-the-encoder-and-the-agent-only-drives-it-over-obs-websocket)
- [Going live takes one word from a human, and everything before it is automatic](#going-live-takes-one-word-from-a-human-and-everything-before-it-is-automatic)
- [The countdown runs on air, so saying the words is publishing](#the-countdown-runs-on-air-so-saying-the-words-is-publishing)
- [Local fanout copies one encode to every platform, so every platform gets the same bitrate](#local-fanout-copies-one-encode-to-every-platform-so-every-platform-gets-the-same-bitrate)
- [obs-websocket 5.x keeps its config in plugin_config, not global.ini, and OBS wipes the keys you put there](#obs-websocket-5x-keeps-its-config-in-plugin_config-not-globalini-and-obs-wipes-the-keys-you-put-there)

---

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

## obs-websocket 5.x keeps its config in `plugin_config`, not `global.ini`, and OBS wipes the keys you put there

**verified:** 2026-09-02, keys written into `[OBSWebSocket]` in `global.ini` were gone after one OBS start, leaving the bare section header
**where:** enabling or reading the OBS websocket without clicking through the UI

The real file is
`%APPDATA%\obs-studio\plugin_config\obs-websocket\config.json`, holding
`server_enabled`, `server_port`, `auth_required` and `server_password` in snake case.
The `global.ini` `[OBSWebSocket]` section with `ServerEnabled` in camel case is the
obs-websocket 4.x layout and OBS 28+ migrates it once and then discards the keys. OBS
rewrites its config on exit, so any edit made while it is running is lost, and the server
only binds the port on start, so a config change needs a restart before `4455` opens.

**Fix:** edit `config.json` with OBS closed, then start OBS and wait for the port. Check
`tasklist.exe /FI "IMAGENAME eq obs64.exe"` before writing, not after.
