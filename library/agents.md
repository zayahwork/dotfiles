# agents

Claude Code, Codex and cursor-agent, and how this repo reaches them.

## Contents

- [One source rules file, `home/AGENTS.md`, deployed to three paths. Never edit the copies.](#three-agents-one-rules-file-three-destinations)
- [Skills reach Claude only. Codex and cursor-agent see `AGENTS.md` and nothing else.](#skills-reach-claude-code-only)

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
