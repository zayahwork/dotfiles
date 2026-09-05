# Generate a YouTube description that matches the reference byte for byte where it should, and fails loudly where it should not

**id:** 003
**type:** AFK
**blocked-by:** 001
**slice:** vertical
**stories:** none directly - it is what makes stories 1 and 2 safe
**from:** prd-stream-agent.md

---

## What done looks like

Given a day's inputs, the generator emits the 21-block description. The fixed blocks are
byte-identical to the captured reference. The four links are present, in order, and each
one resolves. The title passes a spell check.

## Modules touched

`metadata`, `dataset`

## The failing test to write first

`test_fixed_blocks_are_byte_identical`. Generate against the inputs of the 2026-09-01
stream and diff the fixed blocks against `stream/fixtures/Q5dJuLvhxTI.txt`, the captured
3,290-character reference. It fails before implementation because there is no generator.

Then the three regressions taken from the real failure on 2026-09-02:
`test_leading_hashtags_present`, `test_links_are_urls_not_display_text`,
`test_body_mentions_todays_work`.

## Feedback loop

    pytest stream/tests/test_metadata.py -v

Passing prints `21 blocks, 1506 fixed chars identical, 4/4 links resolve, 0 spelling
errors`.

## Not this issue

Not the X, Twitch or Kick variants. Not thumbnails. YouTube's long description only.
