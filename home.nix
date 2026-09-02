{ pkgs, lib, treehouse, ... }:

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
    # lavish-axi and the other AXI tools run through npx, and they need >=22.
    # Without this, npx resolves to the Windows install under /mnt/c and hands
    # WSL paths to a Windows node, which cannot read them.
    nodejs
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

    # A pool of reusable worktrees, so an agent gets an isolated tree
    # instantly instead of paying for a clone every session.
    #
    # Their own flake at v2.3.0 does not build: its test suite asserts on
    # no-mistakes CI gate output and fails in the nix sandbox, which has no
    # git remote and no PR. The code is fine, the check is not ours to run.
    (treehouse.packages.${pkgs.system}.default.overrideAttrs (_: {
      doCheck = false;
    }))

    # Gates a push behind an agent-run validation pipeline before the branch
    # reaches the real remote. Built here: not in nixpkgs, and ships no flake.
    (pkgs.callPackage ./nix/no-mistakes.nix { })
  ];

  # corp-layout builds a herdr workspace per worktree.
  home.file.".local/bin/edit-tab" = {
    source = ./home/bin/edit-tab;
    executable = true;
  };

  home.file.".local/bin/stack-tab" = {
    source = ./home/bin/stack-tab;
    executable = true;
  };

  home.file.".local/bin/agent-tab" = {
    source = ./home/bin/agent-tab;
    executable = true;
  };

  home.file.".local/bin/herdr-focus-rect" = {
    source = ./home/bin/herdr-focus-rect;
    executable = true;
  };

  home.file.".local/bin/herdr-status" = {
    source = ./home/bin/herdr-status;
    executable = true;
  };

  home.file.".local/bin/corp-layout" = {
    source = ./home/bin/corp-layout;
    executable = true;
  };

  home.file.".local/bin/context-bar" = {
    source = ./home/bin/context-bar;
    executable = true;
  };

  home.file.".local/bin/commit-url" = {
    source = ./home/bin/commit-url;
    executable = true;
  };

  home.file.".local/bin/gnhf" = {
    source = ./home/bin/gnhf;
    executable = true;
  };

  # One word for the overnight run, so its objective is never retyped.
  home.file.".local/bin/goodnight" = {
    source = ./home/bin/goodnight;
    executable = true;
  };

  # What we spent and what came out of it, read from what is already on disk.
  home.file.".local/bin/metrics" = {
    source = ./home/bin/metrics;
    executable = true;
  };

  # Switch, but check first that the flake can see every file. A flake only
  # sees what git tracks, and that trap has cost three failed switches.
  home.file.".local/bin/apply" = {
    source = ./home/bin/apply;
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

  # A context bar under the prompt: how full the window is, and the percent.
  #
  # Claude and cursor both run a command and pipe it the session state as JSON, and
  # the two payloads agree down to the key names, so one script drives both.
  #
  # Merged into their config files rather than symlinked from the store, because both
  # agents write those files themselves - /config, theme changes, cursor's own
  # settings - and a read-only symlink would break that. jq rewrites just the
  # statusLine key and leaves the rest of the file alone.
  home.activation.agentContextBar =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      bar="$HOME/.local/bin/context-bar"

      for settings in "$HOME/.claude/settings.json" "$HOME/.cursor/cli-config.json"; do
        mkdir -p "$(dirname "$settings")"

        # A missing or empty file is not valid JSON, so seed it before merging.
        if [ ! -s "$settings" ] || ! ${pkgs.jq}/bin/jq -e . "$settings" >/dev/null 2>&1; then
          echo '{}' > "$settings"
        fi

        # Merge into a temp file first, so a failed jq or a dry run cannot leave
        # the config truncated.
        tmp=$(mktemp)
        ${pkgs.jq}/bin/jq --arg cmd "$bar" \
          '.statusLine = { type: "command", command: $cmd }' \
          "$settings" > "$tmp"

        $DRY_RUN_CMD mv $VERBOSE_ARG "$tmp" "$settings"
      done
    '';

  # codex needs nothing here. It already prints "N% context left" under its
  # composer by default, and it could not draw the bar anyway: its status line
  # takes a fixed set of built-in items and has no "run this command" item.

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

    # Every interactive shell, not just login ones. hm-session-vars.sh only
    # gets sourced by login shells, and herdr panes are not reliably login
    # shells, so cursor-agent and the corp scripts went missing in new panes.
    initContent = ''
      export PATH="$HOME/.local/bin:$PATH"

      # Nobody should have to remember to run the check. A flake cannot see an
      # untracked file, and that trap cost three failed switches before it was
      # caught, so `home-manager switch` routes through apply, which adds any
      # untracked path with git add -N first. Every other subcommand is passed
      # straight through. apply is a bash script, so it calls the real binary
      # rather than recursing into this function.
      home-manager() {
        if [ "$1" = "switch" ]; then
          shift
          command apply "$@"
        else
          command home-manager "$@"
        fi
      }
    '';

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
      v = "nvim";
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
    [session]
    # Bring agent panes back into their own conversation after a full server
    # restart or a reboot, rather than reopening an empty prompt.
    resume_agents_on_restore = true

    [experimental]
    # Keep each pane's scrollback across a server restart too, so the text that
    # was on screen is still there.
    pane_history = true

    [terminal]
    # New panes, tabs and workspaces start in the dotfiles repo rather than in
    # $HOME, so a fresh space is named after the repo instead of "~".
    new_cwd = "~/github/dotfiles"

    # Panes are login shells. herdr's "auto" only does this on macOS, so on
    # Linux every pane skipped hm-session-vars.sh and never saw ~/.local/bin,
    # which is where cursor-agent and the corp scripts live.
    shell_mode = "login"

    # One keypress opens a named tab with that agent already running in it.
    [[keys.command]]
    key = "ctrl+alt+t"
    type = "shell"
    command = "/home/pc/.local/bin/stack-tab"

    [[keys.command]]
    key = "ctrl+alt+shift+n"
    type = "shell"
    command = "/home/pc/.local/bin/edit-tab"

    [[keys.command]]
    key = "ctrl+alt+shift+c"
    type = "shell"
    command = "/home/pc/.local/bin/agent-tab claude"

    [[keys.command]]
    key = "ctrl+alt+shift+x"
    type = "shell"
    command = "/home/pc/.local/bin/agent-tab codex"

    [[keys.command]]
    key = "ctrl+alt+shift+r"
    type = "shell"
    command = "/home/pc/.local/bin/agent-tab cursor"

    # Open the commit you are looking at on GitHub, in the Windows browser. Runs
    # in the focused pane's directory, so it follows whichever repo you are in,
    # and falls back to this one when the pane is not in a repo at all.
    [[keys.command]]
    key = "ctrl+alt+g"
    type = "shell"
    command = "/home/pc/.local/bin/commit-url --open"

    [theme]
    name = "rose-pine"

    [theme.custom]
    # Let the terminal's own background show through the pane area. Without
    # this herdr paints an opaque block over it, so the sidebar looks like
    # frosted glass while the panes look like a solid black rectangle.
    panel_bg = "reset"

    [keys]
    # Prefix is Caps Lock, remapped to F12 by PowerToys on the Windows side.
    prefix = "f12"

    # The everyday actions are direct chords, no prefix needed.
    focus_pane_left  = "ctrl+alt+h"
    focus_pane_down  = "ctrl+alt+j"
    focus_pane_up    = "ctrl+alt+k"
    focus_pane_right = "ctrl+alt+l"
    split_vertical   = "ctrl+alt+v"
    split_horizontal = "ctrl+alt+s"
    zoom             = "ctrl+alt+z"
    close_pane       = "ctrl+alt+x"
    workspace_picker = "ctrl+alt+w"
    next_tab         = "ctrl+alt+n"
    previous_tab     = "ctrl+alt+p"

    # The rare ones stay behind the prefix, out of the way.
    copy_mode       = "prefix+y"
    # Ctrl+Alt+digit never reached herdr on Windows, where that chord is AltGr.
    # Letters work, digits do not. Tab numbers live behind the prefix instead.
    switch_tab      = "prefix+1..9"
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

    # No sidebar. Just the tab strip at the top and the panes underneath.
    # ctrl+alt+w still opens the workspace picker when it is needed.
    sidebar_start_collapsed = true
    sidebar_collapsed_mode = "hidden"

    # A full outline around every pane, gaps between them so each reads as its
    # own box against the wallpaper.
    pane_borders = true
    pane_outer_borders = true
    pane_gaps = true
    pane_scrollbars = false

    # Near white, the brightest token in rose-pine, so the outlines read as
    # deliberate frames rather than faint terminal rules.
    accent = "#e0def4"

    # Let the terminal see plain clicks, so URLs in scrollback are clickable.
    # herdr's own mouse UI goes away with this, which is fine when everything
    # is driven from the keyboard anyway.
    mouse_capture = false

    # One line per notch. The scroll hotkeys send a steady stream of single
    # notches, so the smoothness comes from the rate, not the step size.
    mouse_scroll_lines = 1

    # A thin context strip on the right of the tab bar. herdr-status prints the
    # live agents and their state, and stays empty when none are running.
    tab_bar_right = [
      { type = "command", command = "/home/pc/.local/bin/herdr-status", interval_seconds = 3 },
      { type = "text", text = "  " },
      { type = "datetime", format = "%-I:%M %p" },
    ]
    tab_bar_right_separator = "  "
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
