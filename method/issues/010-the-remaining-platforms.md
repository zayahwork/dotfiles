# Four platforms live at once from one sentence, each with its own native title and description

**id:** 010
**type:** human
**blocked-by:** 009
**slice:** vertical
**stories:** 1, 2
**from:** prd-stream-agent.md

---

## What done looks like

Twitch and Kick endpoints exist and are configured. `metadata` emits a native title and
description per platform from one source. All four go live from one sentence.

## Modules touched

`twitch`, `kick`, `x`, `metadata`, `relay`

## The failing test to write first

`test_per_platform_metadata_is_native`. Assert the four outputs differ in shape, that
none exceeds its platform's real character limit, and that each handle in the links block
resolves. It fails before implementation because `metadata` emits YouTube only.

The handles are data and never derived: `kick.com/corpai` has one `p` and
`x.com/CorppAI` has two, and deriving one from the other is a 404.

## Feedback loop

    pytest stream/tests/test_platforms.py -v

Passing prints four outputs with their lengths against each platform's limit, and
`5/5 handles resolve`.

## Not this issue

Human because the endpoints do not exist yet. Both accounts are real and neither has a
stream key pulled, and that is keyboard work on kick.com and twitch.tv. The real
character limits are also still unread and must be read, never remembered.
