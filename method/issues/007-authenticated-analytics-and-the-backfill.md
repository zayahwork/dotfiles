# Open a page the next morning and find yesterday backfilled with impressions, CTR and retention

**id:** 007
**type:** human
**blocked-by:** 006
**slice:** vertical
**stories:** 5
**from:** prd-stream-agent.md

---

## What done looks like

The OAuth connection exists. A scheduled job runs the morning after a stream, pulls
impressions, CTR, retention and subs, writes them onto yesterday's rows, and updates the
page. Yesterday gets more true overnight instead of being wrong forever.

## Modules touched

`youtube`, `backfill`, `report`, `page`, `dataset`

## The failing test to write first

`test_backfill_fills_only_missing_fields`. Run the backfill twice against the same rows
and assert the second run changes nothing and overwrites no measured value. It fails
before implementation because there is no backfill. Idempotence matters because this runs
unattended on a schedule.

## Feedback loop

    python -m stream.backfill --date 2026-09-01
    pytest stream/tests/test_backfill.py -v

Passing prints `filled 4 fields on 1 stream, overwrote 0`.

## Not this issue

Human because the OAuth consent flow needs a person at a browser once. After that first
consent the job itself is unattended.
