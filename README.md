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
