-- WezTerm on macOS. Opens straight into native herdr, so every session
-- starts inside the multiplexer instead of a bare shell. No WSL.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ---------------------------------------------------------------- what runs --

-- Land in herdr. It attaches to the persistent session if one is already
-- running, so closing this window never loses your panes.
-- Through a login shell on purpose. A GUI-launched WezTerm has a short PATH
-- (no nix, no brew, no ~/.local/bin), and both herdr and pi live there.
-- exec replaces the shell so closing herdr closes the tab.
--
-- Do not start herdr with `brew services`. launchd gives the server
-- /usr/bin:/bin:/usr/sbin:/sbin, and `pi` is `#!/usr/bin/env node`, so the
-- pane dies in about two seconds with no output.
config.default_prog = { "/bin/zsh", "-lic", "exec herdr" }
config.default_cwd = wezterm.home_dir

-- A plain shell, for when herdr itself is the thing you need to fix.
config.launch_menu = {
  { label = "zsh", args = { "/bin/zsh", "-l" } },
}

-- ------------------------------------------------------------------- colors --

-- Rose Pine Moon, written out rather than referenced by name so it renders the
-- same on any WezTerm version.
config.color_schemes = {
  ["rose-pine-moon"] = {
    foreground = "#e0def4",
    background = "#232136",
    cursor_bg = "#56526e",
    cursor_fg = "#e0def4",
    cursor_border = "#56526e",
    selection_fg = "#e0def4",
    selection_bg = "#44415a",
    scrollbar_thumb = "#393552",
    split = "#393552",
    ansi = {
      "#393552", -- black
      "#eb6f92", -- red / love
      "#3e8fb0", -- green / pine
      "#f6c177", -- yellow / gold
      "#9ccfd8", -- blue / foam
      "#c4a7e7", -- magenta / iris
      "#ea9a97", -- cyan / rose
      "#e0def4", -- white / text
    },
    brights = {
      "#6e6a86",
      "#eb6f92",
      "#3e8fb0",
      "#f6c177",
      "#9ccfd8",
      "#c4a7e7",
      "#ea9a97",
      "#e0def4",
    },
  },
}
config.color_scheme = "rose-pine-moon"

-- -------------------------------------------------------------------- glass --

config.window_background_opacity = 0.80
config.macos_window_background_blur = 20
-- How opaque an app-painted cell background is. herdr paints its own panels,
-- status bar and pane backgrounds; at 1.0 those render as solid black blocks
-- over the blur. Low value lets the whole window read as one frosted sheet.
config.text_background_opacity = 0.2

-- Dim a window that is not focused, so the active one is obvious at a glance.
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.7 }

-- --------------------------------------------------------------------- look --

config.font = wezterm.font_with_fallback({
  "JetBrainsMono NF",
  "JetBrainsMono Nerd Font",
  "JetBrainsMono Nerd Font Mono",
  "CaskaydiaCove Nerd Font",
  "Menlo",
})
config.font_size = 13.0
config.line_height = 1.05

-- herdr draws its own tabs and status, so WezTerm's chrome is just noise.
config.enable_tab_bar = false
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 4 }

config.scrollback_lines = 10000
config.audible_bell = "Disabled"

-- ---------------------------------------------------------------------- keys --

-- Keep this list tiny. Anything WezTerm binds is a key herdr never sees, and
-- herdr is the thing doing the multiplexing. Cmd+C / Cmd+V stay at WezTerm
-- defaults on macOS.
config.keys = {
  { key = "n", mods = "CMD", action = wezterm.action.SpawnWindow },
  { key = "l", mods = "CMD", action = wezterm.action.ShowLauncher },
  { key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },
}

return config
