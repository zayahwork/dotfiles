# Stream agent

Type one sentence, go live on every platform at once, get told afterwards how it went.

**Plan:** [`method/issues/prd-stream-agent.md`](../method/issues/prd-stream-agent.md)
**Board:** [`method/issues/BOARD.md`](../method/issues/BOARD.md)
**Grill record:** [`stream-agent.md`](../stream-agent.md), 65 decisions
**Facts:** [`library/stream/`](../library/stream/INDEX.md), 8 subtopics

---

## Where we are

**The spec is finished and the board is cut. Nothing is built.** Eleven issues exist with
blocking edges, seven of them AFK. `001` is the only one ready right now; three more open
the moment it closes.

**The one thing holding everything up is stream keys.** 13 of 15 entries in
`stream/secrets.env` are empty, and every one of them lives behind a login only Zayah can
get through.

## What is next

**1. Zayah: click through the OBS dialog.** OBS was force-restarted and may be sitting on
a safe-mode prompt. Port 4455 is configured but not bound. `./stream/check.sh` turns that
line green when it is.

**2. Zayah: YouTube Studio -> Go Live -> Stream.** Two values into `stream/secrets.env`.
That unblocks `001` and `002`, and `002` is the issue that proves the whole path.

**3. Restart Claude Code so Playwright MCP loads.** It is already configured in
`~/.claude.json` and cannot load mid-session. With it, an agent drives a real browser
that can click, so the remaining keys stop being a manual copy job. Zayah logs in once
by hand in that window.

**Stop after step 2.** X, Twitch, Kick and the YouTube OAuth block belong to phases 7, 9
and 10 and buy nothing today.

## Blocked on a person, not on code

| What | Who | Blocks |
| --- | --- | --- |
| Does X RTMP ingest exist for Premium at all? Nobody has ever gone live | Zayah, one throwaway broadcast | `009`, `010` |
| What "two framings" means: same picture and different words, a vertical cut, or two compositions | Zayah | `009`, and whether it costs a second encoder |
| Does the task board replace "Current Goals" on the canvas | Zayah | `005` |
| What the percent bar measures | Zayah | `005` |
| What feeds the board | Zayah | `005` |
| Where the merged chat feed sits, given the canvas has one free slot and two claimants | Zayah | `011` |
| Twitch and Kick stream keys | Zayah, at a keyboard | `010` |
| YouTube Analytics OAuth consent | Zayah | `007` |
| The four platforms' real character limits | anyone, by reading | `010` |

---

## Previous work

Newest first. Every line carries what proved it.

**2026-09-02, the board.** Eleven issues cut from the PRD, seven AFK and four human, each
naming the failing test to write first and the command that proves it. Chains verified:
`003` and `005` are independent of `002`, and `011` opens with `002`, so three agents can
work at once from the moment `001` closes. `19dd0a0`.

**2026-09-02, the PRD.** 21 modules in five named layers, eleven phases each a vertical
strip, testing decisions written before implementation, Out of scope filled with eight
rejected things and their reasons. `2f4ca4e`, corrected by `89f938a` and `ba5ad83`.

**2026-09-02, chat pulled back into scope.** It had been deferred because a broken chat
websocket must never stop a stream. That reason survives but demands isolation rather
than deferral, so chat is `011`: always running, its own process, invisible to `golive`.
Its test is the isolation, not the feature. `89f938a`.

**2026-09-02, all five handles resolved, and a trap found.** YouTube `@ZayBuilds-b6o`,
X `@CorppAI` and `@ZayahNelson0`, Twitch `twitch.tv/zaysterfps` (GQL id 1518390698,
verified against a fake control returning null), Kick `kick.com/corpai`. **Kick spells
the brand with one `p` and X with two**, so `kick.com/corppai` is a 404 and a generator
that derives one handle from the other ships a dead link. `5f64ef5`, `ccaca36`,
`0a2d608`.

**2026-09-02, `zayster7` ruled out four ways** after being given three times: curl 404,
Kick's API `Channel not found`, a real headless Edge from Windows rendering 683,980 bytes
titled "Channel Not Found", and Kick's search index listing fourteen `zayster*` channels
without it.

**2026-09-02, obs-websocket configured.** Port 4455, auth required, 24-char password
generated and written straight into the gitignored `stream/secrets.env`, never printed.
**Cost an hour to a wall now in the library:** obs-websocket 5.x does not use
`global.ini`; the real file is `plugin_config/obs-websocket/config.json` with snake_case
keys, and OBS migrates the old camel-case section once and then discards it. `adabcdc`.

**2026-09-02, the evidence that moved the plan.** All nine streams on `@ZayBuilds-b6o`
read off live pages. Eight descriptions are 53-113 characters and got 2-36 views; the
ninth is 3,290 and got 256. On `@bridgemindai` seven day-counter formula titles did
16K-77K while three off-formula titles did 5.4K-5.9K in the same weeks. `@carlo2million`
has 49,200 subscribers, empty descriptions and 43-146 views a stream. `de34570`.

**2026-09-02, the failure the project exists to stop, caught in the act.** The
2026-09-01 description was copy-pasted onto 2026-09-02 and broke three ways: leading
hashtags dropped, two links pasted as dead display text, and the body still described the
previous day's stream. All three are checks, none are judgement. `6445696`.

**2026-09-02, the grill.** 65 decisions, from the ask to the shape to the platform
reality. `stream-agent.md`, restored to the repo root on 2026-09-02 after `43715ae`
renamed it away inside a commit about installing cursor-agent and the PRD then overwrote
the path.
