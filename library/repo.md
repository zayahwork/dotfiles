# repo

This repo's own hard rules and the numbers behind them. The canonical text is in
`README.md` and `method/README.md`; this file exists so an agent can check one rule
without reading either of them whole. If the two ever disagree, they are canonical and
this file is the bug.

## Contents

- Branches move `development -> staging -> main`, one direction, no direct commits to the last two.
- Promote with `git merge --no-ff`, never a reset or a cherry-pick.
- `media` is an orphan branch with no shared history. It joins nothing.
- One task, roughly 100K tokens. Clear context, do not compact it.

---

## Never commit directly to staging or main

**verified:** 2026-09-01, `README.md` Branches section
**where:** every commit in this repo

`development` is the only branch written to directly. A change that appears on `main`
without passing through the other two was never let run anywhere, so the branch stops
meaning anything. Promotion is a claim: `staging` claims the draft is revised, `main`
claims it ran and nothing went wrong. Do not make either claim to tidy up the branches.

**Fix:** `git checkout staging && git merge --no-ff development`, then the same into
`main`. A merge, not a reset or a cherry-pick, so the history says where a change came
from.

---

## media is an orphan branch and never merges

**verified:** 2026-09-01, `git branch -vv`, `media` at `beacbfc` on its own root
**where:** finished media only, no drafts and no project files

It has no history in common with the other three, so switching to it swaps the whole
working tree. Commit before you switch. It is separate because anything committed to a
branch stays in that branch's history forever, and a clone of the config should never
have to carry a video file.

---

## One task, roughly 100K tokens, then clear

**verified:** 2026-09-01, `method/README.md`, first two lines of the method
**where:** how sessions are sized

Clear context rather than compacting it, and keep the always-on prompt small.
`home/AGENTS.md` is sent on every single turn, so anything only sometimes relevant goes
behind a skill description or into this library instead.
