# nix

Nix flakes, home-manager and the WSL side of the box.

---

## A file another program writes cannot be a store symlink

**hit:** 2026-09-01
**where:** `home.nix`, `~/.claude/settings.json` and `~/.cursor/cli-config.json`

Deploying an agent settings file with `home.file.<path>.source` puts a read-only symlink
into `$HOME`. Both agents rewrite that file themselves - `/config`, theme changes,
cursor's own settings - and the write fails against the store.

**Why:** everything under `/nix/store` is read-only by design, and the symlink means
the app is writing there whether it knows it or not.
**Fix:** an activation script that merges only the keys we own, with `jq`, into a temp
file first, then moves it into place. See `home.activation.agentContextBar`. The rest of
the file stays whatever the agent last wrote.

Read this as the general rule, not a one-off: own the whole file with a symlink, or own
a few keys with a merge. Never assume a config file has one writer.

---

## What is deployed into $HOME is read-only at runtime

**hit:** 2026-09-01
**where:** `~/.claude/skills`, `~/.claude/CLAUDE.md`

Both are symlinks into `/nix/store/...-home-manager-files/`. Nothing running on the
machine can add to them, and an edit to the repo source does not appear until
`home-manager switch` runs again.

**Why:** `home.file.".claude/skills".source = ./home/.claude/skills` links the directory
itself, not its contents.
**Fix:** anything an agent needs to write during a session lives in the repo working
tree and is read by path, not through `~/.claude/`. That is why `lessons/` sits at the
repo root: an entry can be appended and committed with no rebuild.
