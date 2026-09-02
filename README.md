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

- **development** is where we work and create new stuff. Every commit starts here.
  This is the branch you are on by default, and the only one anything is written
  directly to. Rough is fine here. That is the point of it.
- **staging** is where a thing goes once the rough draft is done and the reviser has
  finished with it. Then we let it run and see what goes wrong. Things are expected to
  break here, and finding out is the job this branch does.
- **main** is live. It only ever holds what has already run in staging without going
  wrong. Nothing arrives here to be tested.

The rule that makes it worth having: **never commit directly to `staging` or `main`.**
A change that appears on `main` without passing through the other two was never let
run anywhere, so nothing knows whether it works, and the branch stops meaning anything.

Which also means a promotion is a claim, not a step. Moving to `staging` claims the
draft is finished being revised. Moving to `main` claims it ran and nothing went
wrong. Do not make either claim to tidy up the branches.

Promote with a merge, not a reset or a cherry-pick, so the history says where a change
came from:

    git checkout staging     && git merge --no-ff development
    git checkout main        && git merge --no-ff staging

Then push the branch you promoted into. Go back to `development` to keep working.
