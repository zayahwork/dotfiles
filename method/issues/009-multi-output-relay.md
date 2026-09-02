# Two endpoints live off one encode, and the number showing what that cost

**id:** 009
**type:** AFK
**blocked-by:** 004
**slice:** vertical
**stories:** none directly - it is what stories 1 and 2 need to mean every platform
**from:** prd-stream-agent.md

---

## What done looks like

One encode leaves OBS and reaches two endpoints as a copy, never a re-encode. Per-output
connection state is reported. CPU is measured before and after so the cost is a number
rather than a belief.

## Modules touched

`relay`, `x`

## The failing test to write first

`test_single_encode_two_outputs`. Run against two local sinks and assert both receive
identical stream bytes and that only one encoder process exists. It fails before
implementation because the relay has one output. Proving byte-identity is what proves it
copied rather than re-encoded.

## Feedback loop

    pytest stream/tests/test_relay.py -v
    python -m stream.relay --outputs 2 --measure-cpu

Passing prints `2/2 connected, 1 encoder, cpu +X%` with the delta measured, not
estimated.

## Not this issue

The X endpoint itself stays behind the open question: nobody has ever gone live on
either X account, so whether Premium has RTMP ingest at all is UNCONFIRMED. This issue
proves the relay against local sinks and does not need X to exist.
