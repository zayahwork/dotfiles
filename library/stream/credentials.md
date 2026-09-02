# Credentials

Where stream keys live and what that costs.

## Contents

- [Stream keys may live in this private repo, and what that costs](#stream-keys-may-live-in-this-private-repo-and-what-that-costs)

---

## Stream keys may live in this private repo, and what that costs

**verified:** 2026-09-02, approved by Zayah, overriding the earlier no-credentials rule
**where:** where stream keys and OAuth tokens live

The original objection was that the repo is on camera, and that was wrong: the repo
is not displayed on the stream. What survives is that a key committed once stays in git
history so rotating does not remove it, an Actions log can print a secret it was handed,
and anyone given repo access later is given the keys with it. The rejected alternative was
one gitignored file on the Acer with the repo holding only the names.

**Why:** A stream key lets anyone broadcast as you. Recorded here with its trade-off rather
than as a bare rule, because the next agent will otherwise re-litigate it.
