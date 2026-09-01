# dotfiles

Declarative WSL Ubuntu environment, managed with Nix flakes and home-manager.
Nix installed 2026-09-01 with the Determinate Systems installer.

## Apply

    cd ~/github/dotfiles
    nix run home-manager/master -- switch --flake .#pc

After the first switch:

    home-manager switch --flake .#pc

## Layout

- `flake.nix` pins nixpkgs and home-manager
- `home.nix` is the actual config: packages, git, zsh, starship
- `home/` is the source for anything deployed into `$HOME`
- `home/AGENTS.md` is the one rules file every agent reads
- `home/.claude/skills/` are the method skills, deployed to `~/.claude/skills/`
- `method/` is the build workflow: vocabulary, templates and an empty board.
  `method/README.md` explains it. Copy its pieces into a new project to start one.

## Branches

Work moves in one direction and never skips a step.

    development  ->  staging  ->  main

- **development** is where work lands. Every commit starts here. This is the branch
  you are on by default, and the only one anything is written directly to.
- **staging** is what has been reviewed and is being exercised. Nothing arrives here
  except by merge from `development`.
- **main** is what is known good. Nothing arrives here except by merge from `staging`.

The rule that makes it worth having: **never commit directly to `staging` or `main`.**
A change that appears on `main` without passing through the other two has skipped the
only checks the flow provides, and the branch stops meaning anything.

Promote with a merge, not a reset or a cherry-pick, so the history says where a change
came from:

    git checkout staging     && git merge --no-ff development
    git checkout main        && git merge --no-ff staging

Then push the branch you promoted into. Go back to `development` to keep working.
