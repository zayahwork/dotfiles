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
- Anything in `home/bin/` is held to the `agent-cli` skill, nine checks, adapted from AXI.

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

---

## Scripts in home/bin are held to the agent-cli skill

**verified:** 2026-09-01, decided after reading <https://github.com/kunchenguid/axi>
**where:** `home/bin/`, and anything an agent shells out to

Our scripts are read by agents and status bars more than by a person, so the bar is
agent ergonomics: say the least that answers, empty is a result rather than silence,
errors are structured and exit non-zero, no interactive prompts. The nine checks are in
the `agent-cli` skill, which is where they belong, because they are only relevant when
you are writing one.

**Rejected:** putting the principles in this library. Every entry here carries a
`verified:` line meaning it was seen on this machine, and an external design spec has no
honest one. Also rejected: installing the upstream AXI skill, which is 15KB written for
published npm CLIs, three of whose ten principles do not apply to a shell script
deployed by home-manager.
