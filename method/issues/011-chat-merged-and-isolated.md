# One feed showing everyone chatting and which platform they are on, and a stream that does not care when it dies

**id:** 011
**type:** AFK
**blocked-by:** 002
**slice:** vertical
**stories:** 6
**from:** prd-stream-agent.md

---

## What done looks like

A merged read-only feed shows every chatter tagged by platform, YouTube first. Killing
the chat process mid-stream stops the feed and changes nothing else: the broadcast, the
overlay and the health line carry on.

## Modules touched

`chat`, `board`, `youtube`

## The failing test to write first

`test_killing_chat_does_not_touch_the_broadcast`. Start a stream against local sinks,
kill the chat process, and assert the broadcast stays up, the health line keeps
reporting, and `golive` never observed the failure. It fails before implementation
because there is no chat process to kill.

This is the whole issue. The merged feed is the feature; the isolation is the
requirement.

## Feedback loop

    pytest stream/tests/test_chat_isolation.py -v

Passing prints `chat down, broadcast up, health up, golive unaware`.

## Not this issue

Read only, always, on every platform. Never writes to any chat: that needs a bot account
per platform with its own rules about automated posting, and it turns commit messages
into public broadcasts. Where the feed sits on the canvas is an open question in the
PRD.
