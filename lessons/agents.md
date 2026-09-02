# agents

Claude Code, Codex and cursor-agent, and how this repo reaches them.

---

## Three agents, one rules file, three destinations

**hit:** 2026-09-01
**where:** `home.nix`, `home/AGENTS.md`

`home/AGENTS.md` is the source. It lands at `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`
and `~/.config/opencode/AGENTS.md`. Editing one of those in place edits a store symlink
and fails, and writing a second rules file for one agent means the three drift.

**Fix:** edit `home/AGENTS.md`, then `home-manager switch`. Anything that is only
sometimes relevant does not belong in it at all - it belongs in a skill behind a
description, or in `lessons/`.

---

## Only Claude Code sees the skills

**hit:** 2026-09-01
**where:** `home/.claude/skills/`, deployed to `~/.claude/skills/`

Codex and cursor-agent read `AGENTS.md` and have no skill mechanism, so anything routed
purely through a skill description is invisible to two of the three agents.

**Fix:** when a thing has to reach all three, it needs a line in `home/AGENTS.md` as
well as the skill. Keep that line to a pointer - a path and when to follow it - because
`AGENTS.md` is sent on every single turn.
