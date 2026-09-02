# nix

Nix flakes, home-manager and the WSL side of the box.

## Contents

- [A file another program writes cannot be a store symlink. Merge the keys you own.](#a-config-file-another-program-writes-cannot-be-deployed-as-a-store-symlink)
- [Everything deployed into `$HOME` is read-only until the next `home-manager switch`.](#anything-deployed-into-home-is-read-only-and-stale-until-the-next-switch)
- [A flake cannot see an untracked file. `home-manager switch` routes through `apply`, which fixes it.](#a-flake-cannot-see-a-file-git-does-not-track)

---

## A config file another program writes cannot be deployed as a store symlink

**verified:** 2026-09-01, `home.activation.agentContextBar` in `home.nix`
**where:** `~/.claude/settings.json`, `~/.cursor/cli-config.json`

`home.file.<path>.source` puts a read-only symlink into `$HOME`. Both agents rewrite
that file themselves - `/config`, theme changes, cursor's own settings - and the write
lands on `/nix/store`, which is read-only by design.

**Fix:** an activation script that merges only the keys we own, with `jq`, into a temp
file, then moves it into place. The rest of the file stays whatever the agent last
wrote. The general rule: own the whole file with a symlink, or own a few keys with a
merge, and never assume a config file has one writer.

---

## Anything deployed into $HOME is read-only, and stale until the next switch

**verified:** 2026-09-01, `ls -ld ~/.claude/skills ~/.claude/CLAUDE.md`, both symlinks
into `/nix/store/...-home-manager-files/`
**where:** `~/.claude/skills`, `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`

Nothing running on the machine can add to them, and an edit to the repo source does not
appear until `home-manager switch` runs again.

**Why:** `home.file.".claude/skills".source = ./home/.claude/skills` links the directory
itself, not its contents.
**Fix:** anything an agent writes during a session lives in the repo working tree and is
read by path. That is why `library/` sits at the repo root: an entry can be appended and
committed with no rebuild.

---

## A flake cannot see a file git does not track

**verified:** 2026-09-01, `home-manager switch` failed on a new `home/bin/commit-url`
**where:** any new file referenced from `home.nix`

The error is buried under a `derivationStrict` stack trace, and the real line is near
the bottom:

```
error: Path 'home/bin/commit-url' in the repository "/home/pc/github/dotfiles" is not
tracked by Git.
```

**Why:** a flake build only sees the git tree, so a brand new file is invisible no
matter that it sits right there in the working directory.
**Fix:** `apply`, and nothing to remember: a zsh function routes `home-manager switch`
through it, so the check runs whichever command gets typed. It lists what git does not track,
adds it with `git add -N` so the path is known without staging its contents, and only
then switches. `apply --check` reports without touching anything.

**Why a command and not this entry:** this was written down after the first failure and
happened twice more anyway, on 2026-09-01 and 2026-09-02. A trap that repeats past being
documented needs a check, not a better entry. That is the general rule now, and it is in
`home/AGENTS.md`.
