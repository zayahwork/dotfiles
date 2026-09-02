# Measuring

Where the numbers come from and what they are allowed to claim.

## Contents

- [Impressions and CTR are owner-only, so a public watch page cannot measure a title](#impressions-and-ctr-are-owner-only-so-a-public-watch-page-cannot-measure-a-title)
- [A live broadcast cannot be split-tested, so the test is sequential and the VOD is the fast lane](#a-live-broadcast-cannot-be-split-tested-so-the-test-is-sequential-and-the-vod-is-the-fast-lane)
- [A claim needs five observations, one direction, and a bigger effect than the untouched drift](#a-claim-needs-five-observations-one-direction-and-a-bigger-effect-than-the-untouched-drift)

---

## Impressions and CTR are owner-only, so a public watch page cannot measure a title

**verified:** 2026-09-02, a watch page returns viewCount and nothing else
**where:** any claim about what a title did

A healthy CTR with low views is a reach problem and a low CTR with decent impressions
is a title and thumbnail problem. Those are completely different fixes and view count
alone cannot tell them apart. The agent therefore needs an authenticated YouTube Analytics
connection, approved 2026-09-02, and without it the whole title-tracking half degrades to
counting views.

**Why:** Views are the number everyone quotes and the one that answers nothing.

## A live broadcast cannot be split-tested, so the test is sequential and the VOD is the fast lane

**verified:** 2026-09-02, decided in the stream agent grill
**where:** A/B testing titles and descriptions

One broadcast has one title at one moment, so giving YouTube title A and X title B
measures YouTube against X, not A against B. The real test is across streams, compared
within each platform separately, four independent tests running in parallel off one
schedule. The VOD is where it resolves in days rather than months, because the content is
fixed and the title can change repeatedly against it.

**Why:** Carrying a winner from one platform to another is worth doing and is not evidence of
anything. Record it as a transfer, never as a result.

## A claim needs five observations, one direction, and a bigger effect than the untouched drift

**verified:** 2026-09-02, the bar set for library-admin
**where:** anything an agent wants to write into the library

Five changes of the same class on five different subjects, all moving the same
direction, with the median effect larger than the largest swing over the same window in
the population nobody touched. The third check is the one that does the work, because
untouched subjects drift on their own and are a free control group.

**Why:** Without a control, an agent reports that a change caused something the algorithm was
doing anyway, and it will be sincere about it.
