# agents

Claude Code, Codex and cursor-agent, and how this repo reaches them.

## Contents

- [One source rules file, `home/AGENTS.md`, deployed to three paths. Never edit the copies.](#three-agents-one-rules-file-three-destinations)
- [Skills reach Claude only. Codex and cursor-agent see `AGENTS.md` and nothing else.](#skills-reach-claude-code-only)
- [`home/.claude/agents/` holds a file per subagent, and `library-admin` is the only thing that writes to `library/`.](#homeclaudeagents-holds-a-file-per-subagent-and-library-admin-is-the-only-thing-that-writes-to-library)
- [Five observations, one direction, bigger than the untouched drift, or the claim is not written.](#five-observations-one-direction-bigger-than-the-untouched-drift-or-the-claim-is-not-written)
- [Push to `development` on commit. Standing yes. Staging and main still need a person.](#push-to-development-on-commit-standing-yes-staging-and-main-still-need-a-person)

---

## Three agents, one rules file, three destinations

**verified:** 2026-09-01, the three `AGENTS.md` deployments in `home.nix`. All three
targets symlink into the same store path.
**where:** `home/AGENTS.md`

The source is `home/AGENTS.md`. It lands at `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`
and `~/.config/opencode/AGENTS.md`, which are the same bytes on disk. Editing one of
those in place edits a store symlink and fails, and writing a second rules file for one
agent means the three drift.

**Fix:** edit `home/AGENTS.md`, then `home-manager switch`. Anything only sometimes
relevant does not belong in it at all: it goes in a skill behind a description, or in
`library/`.

---

## Skills reach Claude Code only

**verified:** 2026-09-01, `home.file.".claude/skills"` is the only skill deployment in
`home.nix`
**where:** `home/.claude/skills/`, deployed to `~/.claude/skills/`

Codex and cursor-agent read `AGENTS.md` and have no skill mechanism, so anything routed
purely through a skill description is invisible to two of the three agents.

**Fix:** when a thing has to reach all three, it needs a line in `home/AGENTS.md` as
well as the skill. Keep that line to a pointer, a path and when to follow it, because
`AGENTS.md` is sent on every single turn.

---

## `home/.claude/agents/` holds a file per subagent, and `library-admin` is the only thing that writes to `library/`

**verified:** 2026-09-02, `home.file.".claude/agents"` added to `home.nix`, `apply --check` clean
**where:** defining a subagent, or writing anything into `library/`

A definition in `home/.claude/agents/` is the only place a subagent is written down, so
an agent nobody can read is an agent nobody can fix. It deploys to `~/.claude/agents/`
exactly as skills do, with the same limit: Claude Code sees it, Codex and cursor-agent do
not. `library-admin` is the gate. Do not edit a library file directly; hand it the claim,
the rows behind it, and the topic it would live under.

**Why:** the agent proposing an entry already believes the claim, so an approver would
rubber stamp. The admin's job is to refute and its default verdict is reject.

## Five observations, one direction, bigger than the untouched drift, or the claim is not written

**verified:** 2026-09-02, the bar set for `library-admin` during the stream agent grill
**where:** any entry that claims one thing caused another

Five observations of the same class from five different subjects, all moving the same
direction, and the median effect larger than the largest swing over the same window in
the population nobody touched. Four is not five, and four-and-one is not four. A claim
that fails is not deleted: it goes to tier two of its subject under `Held back`, with the
reason and the numbers so far.

**Why:** things drift on their own, and the untouched population is a free control group
sitting right there. Without it an agent reports the drift as its own result, sincerely.

## Push to `development` on commit. Standing yes. Staging and main still need a person

**verified:** 2026-09-02, standing approval given by Zayah after commit links 404ed
**where:** every commit made in this repo

`commit-url` is how the work gets reviewed, and an unpushed commit makes that link a 404
even for the owner. So commit, `git push origin development`, then give the link.
Promoting to `staging` or `main` is unchanged and still needs a person to say yes.

**Why:** the 404 is not a permissions problem and not a broken link. The commit simply
was not on the remote yet, and the fix is to stop leaving it local.
