# Say one sentence to stop and get the day's real numbers, plus what we are trying next time

**id:** 006
**type:** AFK
**blocked-by:** 002
**slice:** vertical
**stories:** 4
**from:** prd-stream-agent.md

---

## What done looks like

Every stream writes its rows. On stop the terminal prints the day's numbers and the one
variable being tried next time. The rows behind every printed number exist in the
dataset and can be pointed at.

## Modules touched

`report`, `dataset`, `experiment`

## The failing test to write first

`test_every_printed_number_has_a_row`. Render the stop report from fixture rows and
assert each number in the output is traceable to a dataset row id. It fails before
implementation because there is no report. This is the test that stops the report
inventing a number, which is decision 13 as code.

## Feedback loop

    pytest stream/tests/test_report.py -v
    python -m stream.report --from-fixtures

Passing prints the report with a row id beside every figure.

## Not this issue

Not impressions, CTR or retention - those are owner-only and arrive in 007. This issue
prints what a public read can see, and says so where a number is missing.
