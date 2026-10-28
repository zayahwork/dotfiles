# npm

npm package execution failures and the measured recovery paths.

## Contents

- [Held back: `n8n@2.45.5` npm exec stayed in package installation for 7:54:08, grew a 3.0G cache, and required KILL at n=1.](#held-back)

---

## Held back

### `n8n@2.45.5` npm exec stayed in package installation for 7:54:08, grew a 3.0G cache, and required KILL at n=1

**verified:** 2026-10-28, Codex transcript `rollout-2026-10-27T23-31-22-01a18134-c64f-7b23-a1c6-c50658ccd637.jsonl` recorded the process, byte, directory, cache, npm-log, TERM, and KILL command outputs
**where:** `npm exec --yes --package=n8n@2.45.5` from `/Users/zayah/Documents/Codex/2026-10-27/referenced-chatgpt-conversation-this-is-an/work`

At 7:53:57, `n8n-import.log` was 22,927 bytes of npm warnings, `n8n-user` had no files, and the process had not reached the n8n import; at 7:54:08, `npm-cache` was 3.0G and npm log tarball fetch durations were 27,992,157 to 27,997,368 ms. `kill -TERM` left PID 5319 alive; `kill -KILL` removed it. The cause is UNCONFIRMED because the turn was interrupted while package installation was active.

**Why:** REJECT as a general causal claim at n=1 from one package installation subject; the transcript proves the wall, not why npm took that long.
**Fix:** stop the installer with KILL after TERM failed, then validate the workflow through local JSON, graph, embedded JavaScript, and static SQL checks.
