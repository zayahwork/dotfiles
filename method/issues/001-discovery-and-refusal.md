# Run the agent cold and it tells you your real OBS scenes, or names the credential it is missing and refuses

**id:** 001
**type:** AFK
**blocked-by:** none
**slice:** vertical
**stories:** 1
**from:** prd-stream-agent.md

---

## What done looks like

A first run against a live OBS writes `stream/config.json` naming the actual scenes and
sources found over obs-websocket, never a guessed name. A second run with a key removed
from `stream/secrets.env` exits non-zero and prints which key, not a stack trace.

## Modules touched

`secrets`, `config`, `obs`

## The failing test to write first

`test_refuses_and_names_the_missing_key`. Point `secrets` at a file with
`OBS_WEBSOCKET_PASSWORD` blank and assert the process exits non-zero with that exact key
name in stderr. Before any implementation it fails because nothing exits at all. Confirm
it fails for that reason and not an import error.

Then `test_discovery_writes_real_names`: connect to obs-websocket, assert
`config.json` contains at least one scene name and that no name in it is hardcoded
anywhere in the source.

## Feedback loop

    ./stream/check.sh          # the OBS block must be green first
    pytest stream/tests/test_discovery.py -v

Passing prints `config.json` with the real scene list, and the refusal run prints
`missing: OBS_WEBSOCKET_PASSWORD` and exits 1.

## Not this issue

Does not start a broadcast, does not set any text source, does not touch scene
composition. Read and refuse only.
