# Platforms

Which endpoints exist, which do not, and what gates them.

## Contents

- [The channel is @ZayBuilds-b6o, and @CorpAI is a music channel with no streams on it](#the-channel-is-zaybuilds-b6o-and-corpai-is-a-music-channel-with-no-streams-on-it)
- [Twitch simulcasting rules bind Affiliates and Partners, and this account is neither](#twitch-simulcasting-rules-bind-affiliates-and-partners-and-this-account-is-neither)
- [The first working version is YouTube plus two X accounts, not four platforms](#the-first-working-version-is-youtube-plus-two-x-accounts-not-four-platforms)
- [Neither X account has ever gone live, so X RTMP ingest is UNCONFIRMED](#neither-x-account-has-ever-gone-live-so-x-rtmp-ingest-is-unconfirmed)
- [Two framings for two X accounts means a second encode, unless framing means the words](#two-framings-for-two-x-accounts-means-a-second-encode-unless-framing-means-the-words)
- [The Kick account exists and is not configured](#the-kick-account-exists-and-is-not-configured)
- [Every account exists; what does not exist is endpoints](#every-account-exists-what-does-not-exist-is-endpoints)

---

## The channel is @ZayBuilds-b6o, and @CorpAI is a music channel with no streams on it

**verified:** 2026-09-02, `@CorpAI` video 0HkeCbFqzJ0 is a 2 minute track with 9 views
**where:** any lookup of the stream channel

Nine streams exist on `@ZayBuilds-b6o`, from 2026-08-27 to 2026-09-02. An earlier
version of the plan named CorpAI as the streaming channel and it is not one.

**Why:** `@CorpAI` publishes copyright-free music. Searching it for streams returns nothing
because there are none, not because YouTube is hiding them.

## Twitch simulcasting rules bind Affiliates and Partners, and this account is neither

**verified:** 2026-09-02, stated by Zayah; the policy text itself is UNCONFIRMED
**where:** creating the Twitch endpoint

The account exists under the `zayahwork@gmail.com` Google login and is not Affiliate
or Partner, so the funnel that cross-links all four platforms is clear to build. The
policy could not be read from this machine because help.twitch.tv is a JavaScript app.
Re-check the day Affiliate is accepted.

**Why:** Affiliate arrives quietly. The rules switch on without anything visibly changing,
and three decisions would be in breach at that moment.

## The first working version is YouTube plus two X accounts, not four platforms

**verified:** 2026-09-02, Twitch and Kick accounts do not exist yet
**where:** planning the relay's outputs

YouTube is set up. Two X accounts both have Premium, so both can go live, which is
two X endpoints rather than one. Twitch has an account but no endpoint yet, and Kick has
neither. Account creation is human work and cannot be done AFK.

**Why:** Whether X RTMP ingest actually works on either account is UNCONFIRMED and is the
most likely thing to knock a platform off the list.

## Neither X account has ever gone live, so X RTMP ingest is UNCONFIRMED

**verified:** 2026-09-02, stated by Zayah when asked directly
**where:** planning any X endpoint

Both accounts have Premium and both can be set up on request, but neither has ever
broadcast. That confirms nobody has tried, not that it works. X RTMP ingest has
historically been gated, so this stays the most likely thing to knock a platform off the
list.

**Fix:** one throwaway broadcast to one account, before anything is designed around X.
Until that passes, the first working version is YouTube alone.

## Two framings for two X accounts means a second encode, unless framing means the words

**verified:** 2026-09-02, decision 38 against decision 3 in `method/issues/prd-stream-agent.md`
**where:** designing the relay's outputs

Decision 3 is cheap because it copies one encode rather than re-encoding. Two different
pictures cannot come out of one encode, so two genuinely different framings is a second
encoder on a laptop already running a game and an OBS composite. Three readings at three
prices: same picture with different titles, descriptions and pinned posts costs nothing;
a 9:16 vertical cut costs one encode and one scale; two full compositions cost that plus
scene work the agent is not allowed to do.

**Fix:** same picture, different words. It gets both accounts reading as distinct and
funnelling into each other without spending a frame of the game, and the measurement to
justify a real second encode will exist by the time it is worth having.

## The Kick account exists and is not configured

**verified:** 2026-09-02, created by Zayah under the `zayahwork@gmail.com` login
**where:** the Kick endpoint

The account exists. There is no profile, no customisation and no stream key pulled, so
there is no endpoint yet. Twitch is in the same state.

**Fix:** keyboard work on kick.com and twitch.tv. It cannot be done from this machine and
does not run AFK.

## Every account exists; what does not exist is endpoints

**verified:** 2026-09-02, logins given by Zayah when reviewing the PRD
**where:** any question about which login owns which platform

YouTube is `@ZayBuilds-b6o` under `zayahnelson97@gmail.com`. X is `@CorppAI` under
`zayahwork@gmail.com` and `@ZayahNelson0` under `zayahwork1@gmail.com`, both Premium.
Twitch and Kick are both under `zayahwork@gmail.com` and their handles are still not
written down. Four platforms, five accounts, and only YouTube has ever broadcast.

**Why:** "blocked" on this project has never meant a missing account. It means no stream
key pulled, no endpoint configured, and in X's case no evidence the ingest exists at all.
Do not read an existing account as a working endpoint.
