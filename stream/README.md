# stream

The stream agent's deterministic core. The plan is `method/issues/prd-stream-agent.md`,
the issues are `method/issues/0*.md`, and the facts are `library/stream/`. This file is
the contract for anyone writing code in here.

## Run it

Python 3.9 or newer, standard library only. No pip dependency at runtime.

    python -m pytest stream/tests -q          # everything, with fakes, no keys needed
    python -m stream.secrets                  # which keys are set (values never printed)
    python -m stream.check                    # is this machine ready: OBS, handles, secrets
    python -m stream.discovery                # P1: list the real OBS scenes, write config.json
    python -m stream.golive --dry-run         # P2: the brief, presses nothing

Tests need pytest. `pip install -r stream/requirements-dev.txt`, or on a nix machine
`nix shell nixpkgs#python3Packages.pytest --command python3 -m pytest stream/tests -q`.
Two tests need `ffmpeg` on PATH to run the real relay against local sinks; they skip
with a reason when it is absent.

Same commands on macOS, Windows (PowerShell or cmd) and WSL. Nothing in the package
shells out to a Unix-only tool without a Windows branch beside it.

## The rules of the package

**Every path comes from `stream/paths.py`.** Secrets, config and data are resolved at
call time from `STREAM_SECRETS`, `STREAM_CONFIG`, `STREAM_DATA`, so tests point them at
a temp dir. Never build a path from `__file__` or a home directory anywhere else.

**Every credential comes from `stream/secrets.py`,** by the names in
`secrets.example.env`. `secrets.load().require_adapter("obs")` raises `MissingSecret`
naming the blank keys; a CLI turns that into `missing: KEY` on stderr and exit 1 via
`secrets.refuse(exc)`. A value is never printed, logged or put in an exception.

**Every real service has a fake behind the same interface.** `obs.py` has `RealObs`
and `FakeObs`; the relay, YouTube, X, Twitch, Kick and chat adapters follow the same
shape. A module-level `connect(...)`/`open(...)` picks the real one only when
`secrets.has_adapter(...)` is true, and every test drives the fake. The fake records
what was called, so a test can assert `StartStream` was never sent.

**Every number in a report has a row id.** Writes go through `stream/dataset.py`,
append-only JSONL. A figure that cannot point at a row is not printed.

**The agent may do three things to OBS:** switch scene, set a named text source, start
or stop the broadcast. There is no fourth method on the OBS interface and no issue is
allowed to add one.

**Nothing publishes without a word from a human.** The only call that starts a
broadcast is behind a confirm step that reads from an input the test can close.

**Handles are data, never derived.** `kick.com/corpai` has one p and `x.com/CorppAI`
has two. They live in one place as literals and are checked, never constructed.

**Writing style in code and output** follows `home/AGENTS.md`: plain hyphens, no em or
en dashes, 12-hour Pacific times, absolute dates.

## Layout

| Layer | Module | Issue |
| --- | --- | --- |
| Storage | `paths`, `secrets`, `config`, `dataset` | foundation |
| Adapter | `obs` | 001 |
| Adapter | `relay` | 009, watched by 004 |
| Adapter | `youtube` | 002 (stream), 007 (analytics), 011 (chat) |
| Adapter | `x`, `twitch`, `kick`, `platforms` | 010 |
| Service | `discovery`, `check` | 001 |
| Service | `metadata` | 003 (YouTube), 010 (native per platform) |
| Service | `golive`, `brief` | 002 |
| Service | `health` | 004 |
| Service | `report` | 006 |
| Service | `experiment`, `admin` | 008 |
| Service | `backfill`, `page` | 007 |
| Service | `chat` | 011 |
| Surface | `board` | 005 |
| Data | `fixtures/Q5dJuLvhxTI.txt` the 3,290-character reference; `fixtures/mdZd7NL2fq8.txt` the copy that broke on 2026-09-02 | 003 |

Generated files: `stream/config.json` (gitignored, one machine's OBS), `stream/data/`
(the dataset, committed, append-only), `stream/secrets.env` (gitignored, never leaves
the Acer).
