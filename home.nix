{ pkgs, ... }:

{
  home.username = "pc";
  home.homeDirectory = "/home/pc";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    fzf
    bat
    eza
    zoxide
    htop
    tree
    gh
    curl
    wget
    unzip
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "zayahwork";
      user.email = "zayahwork@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 50000;

    shellAliases = {
      ls = "eza";
      ll = "eza -l --git";
      la = "eza -la --git";
      cat = "bat --paging=never";
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline -20";
      brain = "cd /mnt/c/Brain";
      builder = "cd /mnt/c/Corp-builder";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
