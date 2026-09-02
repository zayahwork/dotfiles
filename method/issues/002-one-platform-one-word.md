# Say one sentence and YouTube goes live, the countdown runs on air, and the main scene arrives at zero

**id:** 002
**type:** human
**blocked-by:** 001
**slice:** vertical
**stories:** 1, 2
**from:** prd-stream-agent.md

---

## What done looks like

A real broadcast happened. The terminal printed the brief first, waited, and only
pressed the button after one word. The countdown scene was visible on the live stream and
the main scene replaced it at zero without anybody touching OBS.

## Modules touched

`golive`, `obs`, `youtube`, `brief`, `secrets`, `config`

## The failing test to write first

`test_never_publishes_without_the_word`. Drive `golive` with the confirm input closed
and assert `StartStream` is never called on the obs adapter. It fails before
implementation because there is no `golive`. This is the test that matters most in this
issue: everything else here is observable, this one is not.

## Feedback loop

    python -m stream.golive --dry-run     # prints the brief, presses nothing
    python -m stream.golive               # asks, waits, then goes live

Passing means the dry run prints title, yesterday's numbers and the green checks and
exits without a broadcast existing.

## Not this issue

Not multi-platform. Not health monitoring. Not the stop report. One endpoint, one
countdown, one main scene.
