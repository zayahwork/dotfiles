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

  # corp-layout builds a herdr workspace per worktree.
  home.file.".local/bin/corp-layout" = {
    source = ./home/bin/corp-layout;
    executable = true;
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  # One memory file, every agent reads it.
  home.file.".claude/CLAUDE.md".source = ./home/AGENTS.md;
  home.file.".codex/AGENTS.md".source = ./home/AGENTS.md;
  xdg.configFile."opencode/AGENTS.md".source = ./home/AGENTS.md;

  # The method skills, pulled by any project rather than copied into each one.
  # The scaffolding they refer to is in method/.
  home.file.".claude/skills".source = ./home/.claude/skills;

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
      cc = "claude";
      cx = "codex";
      cr = "cursor-agent";

      brain = "cd /mnt/c/Brain";
      builder = "cd /mnt/c/Corp-builder";
      debugger = "cd /mnt/c/Corp-debugger";
      ceo = "cd /mnt/c/Corp-ceo";
      runner = "cd /mnt/c/Corp-runner";
      corp = "corp-layout";
    };
  };

  xdg.configFile."herdr/config.toml".text = ''
    [keys]
    # Prefix is Caps Lock, remapped to F12 by PowerToys on the Windows side.
    prefix = "f12"

    # The everyday actions are direct chords, no prefix needed.
    focus_pane_left  = "ctrl+alt+h"
    focus_pane_down  = "ctrl+alt+j"
    focus_pane_up    = "ctrl+alt+k"
    focus_pane_right = "ctrl+alt+l"
    new_tab          = "ctrl+alt+t"
    split_vertical   = "ctrl+alt+v"
    split_horizontal = "ctrl+alt+s"
    zoom             = "ctrl+alt+z"
    close_pane       = "ctrl+alt+x"
    workspace_picker = "ctrl+alt+w"
    next_tab         = "ctrl+alt+n"
    previous_tab     = "ctrl+alt+p"
    switch_tab       = "ctrl+alt+1..9"

    # The rare ones stay behind the prefix, out of the way.
    copy_mode       = "prefix+y"
    goto            = "prefix+g"
    detach          = "prefix+q"
    help            = "prefix+?"
    settings        = "prefix+s"
    reload_config   = "prefix+shift+r"
    toggle_sidebar  = "prefix+b"
    resize_mode     = "prefix+r"
    close_tab       = "prefix+shift+x"
    new_workspace   = "prefix+shift+n"
    new_worktree    = "prefix+shift+g"
    rename_tab      = "prefix+shift+t"

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
