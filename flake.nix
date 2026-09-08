{
  description = "zayah dotfiles - Linux (WSL Ubuntu) and macOS, managed by home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A pool of reusable worktrees, so an agent gets an isolated tree without
    # paying for a clone. Pinned to a release tag rather than HEAD, because it
    # is somebody else's repo and a surprise there should not break a switch.
    treehouse = {
      url = "github:kunchenguid/treehouse/v2.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, treehouse, ... }:
    let
      # One pkgs set per system. Linux boxes stay on x86_64-linux. A MacBook
      # Air is aarch64-darwin. Intel Macs use x86_64-darwin via mkHomeFor.
      mkPkgs = system: import nixpkgs {
        inherit system;
        # claude-code ships under Anthropic's own licence, which nixpkgs marks unfree.
        # Allow that one package by name rather than opening the whole tree.
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
      };

      # Same home.nix on every box. The system is the only thing that has to
      # match the machine, or the switch builds for the wrong CPU.
      mkHomeFor = system: username:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit treehouse username; };
        };

      # Linux bootstrap still writes `"user" = mkHome "user";`. Keep that
      # working. Mac bootstrap writes mkHomeFor with the detected darwin system.
      mkHome = mkHomeFor "x86_64-linux";
    in {
      # One entry per machine this repo runs on. Same home.nix, same packages,
      # same keys: the only thing that differs is the username, and that is
      # the one thing home-manager will not let you get wrong. `apply` picks
      # the right entry from `id -un`, so the command is identical everywhere.
      homeConfigurations = {
        "pc" = mkHome "pc";
        "stuck" = mkHome "stuck";
        # BOOTSTRAP-INSERTS-MACHINES-HERE
      };
    };
}
