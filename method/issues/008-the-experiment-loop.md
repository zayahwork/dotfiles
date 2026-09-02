# See a claim rejected, with its reason, instead of a confident number nobody checked

**id:** 008
**type:** AFK
**blocked-by:** 007
**slice:** vertical
**stories:** none directly - it is what keeps stories 4 and 5 honest
**from:** prd-stream-agent.md

---

## What done looks like

One variable per stream is recorded as a commitment and checked next stream that it was
actually run. Claims go to `library-admin`, which mostly rejects them, and every verdict
including every rejection lands in the dataset with its reason.

## Modules touched

`experiment`, `dataset`, `library-admin`

## The failing test to write first

`test_rejects_at_n_equals_three`. Feed `library-admin` a claim backed by 3 rows and
assert the verdict is REJECT, that nothing is written under `library/`, and that the
rejection row exists with its reason. It fails before implementation because nothing
calls the admin yet.

Then `test_rejects_when_it_loses_to_untouched_drift`: 5 rows, same direction, but a
smaller median effect than the untouched control. Must still reject. This is the check
that does the real work.

## Feedback loop

    pytest stream/tests/test_experiment.py -v

Passing prints `REJECT: n=3, needs 5` and `REJECT: effect 0.4pp < untouched drift
1.1pp`, and `library/` is unchanged.

## Not this issue

Not proposing claims on its own yet. This issue builds the gate and proves it says no.
