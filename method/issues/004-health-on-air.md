# Watch the terminal during a stream and see upload, dropped frames, and which endpoints are still connected

**id:** 004
**type:** AFK
**blocked-by:** 002
**slice:** vertical
**stories:** 3
**from:** prd-stream-agent.md

---

## What done looks like

Upload is measured before go-live and printed in the brief. During a stream the terminal
carries a live line with dropped frames and per-endpoint connection state. Pulling an
endpoint names it within seconds and does not disturb the others.

## Modules touched

`health`, `relay`, `obs`, `brief`

## The failing test to write first

`test_names_the_dropped_endpoint`. Run the relay against two local RTMP sinks, kill one,
and assert the health line names that sink within 5 seconds while the other stays
connected. It fails before implementation because there is no health module. Uses local
sinks so this proves out without publishing anything.

## Feedback loop

    ffmpeg -f flv -listen 1 -i rtmp://127.0.0.1:1935/a -f null -   # sink A
    ffmpeg -f flv -listen 1 -i rtmp://127.0.0.1:1936/b -f null -   # sink B
    pytest stream/tests/test_health.py -v

Passing prints the dropped sink's name and `1/2 connected` within 5 seconds.

## Not this issue

Not alerting anybody. Not stopping the stream on a drop. Reporting only.
