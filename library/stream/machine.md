# The machine and where things run

The Acer, the bandwidth, and which work is allowed off it.

## Contents

- [The live path runs in a terminal on the Acer and nothing about it is hosted](#the-live-path-runs-in-a-terminal-on-the-acer-and-nothing-about-it-is-hosted)
- [Scheduled work belongs in GitHub Actions, live work never does](#scheduled-work-belongs-in-github-actions-live-work-never-does)

---

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
