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
    claude-code
    codex
    herdr
    lazygit
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

  # One memory file, every agent reads it.
  home.file.".claude/CLAUDE.md".source = ./home/AGENTS.md;
  home.file.".codex/AGENTS.md".source = ./home/AGENTS.md;
  xdg.configFile."opencode/AGENTS.md".source = ./home/AGENTS.md;

  # Neovim config lives in the repo, not hand edited in place.
  xdg.configFile."nvim/init.lua".source = ./home/.config/nvim/init.lua;
  xdg.configFile."nvim/lua".source = ./home/.config/nvim/lua;

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

  xdg.configFile."herdr/config.toml".text = ''
    [keys]
    prefix = "f12"
    focus_pane_left  = "prefix+h"
    focus_pane_down  = "prefix+j"
    focus_pane_up    = "prefix+k"
    focus_pane_right = "prefix+l"
    split_horizontal = "prefix+double_quote"
    split_vertical   = "prefix+percent"
    new_tab   = "prefix+c"
    close_tab = "prefix+ampersand"
    workspace_picker = "prefix+w"
    goto             = "prefix+g"
    copy_mode = "prefix+y"

    [ui]
    agent_panel_sort = "spaces"
  '';

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
