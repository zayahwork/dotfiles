-- WezTerm. Opens straight into WSL Ubuntu running herdr, so every session
-- starts inside the multiplexer instead of a bare shell.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ---------------------------------------------------------------- what runs --

-- Land in herdr. It attaches to the persistent session if one is already
-- running, so closing this window never loses your panes.
-- Through a login shell on purpose. Running "wsl.exe -- herdr" directly exits
-- 127, because a non-login shell never sources Nix's PATH and herdr lives in
-- ~/.nix-profile/bin. exec replaces the shell so closing herdr closes the tab.
--
-- zsh is spelled out by path for the same reason. "-- zsh" exits 127 too: the
-- shell wsl.exe runs the command in has not sourced hm-session-vars either, so
-- it cannot find zsh any more than it could find herdr. Naming one of them by
-- path is enough, because that zsh is a login shell and sets the PATH the rest
-- of the line needs. Caught when ctrl+alt+g opened a window that shut instantly.
config.default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~/github/dotfiles", "--", "~/.nix-profile/bin/zsh", "-lic", "exec herdr" }
config.default_cwd = wezterm.home_dir

-- A plain shell, for when herdr itself is the thing you need to fix.
config.launch_menu = {
  { label = "Ubuntu shell", args = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" } },
  { label = "PowerShell",   args = { "powershell.exe", "-NoLogo" } },
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
config.win32_system_backdrop = "Acrylic"
-- How opaque an app-painted cell background is. herdr paints its own panels,
-- status bar and pane backgrounds; at 1.0 those render as solid black blocks
-- over the acrylic. Low value lets the whole window read as one frosted sheet.
config.text_background_opacity = 0.2

-- Dim a window that is not focused, so the active one is obvious at a glance.
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.7 }

-- --------------------------------------------------------------------- look --

config.font = wezterm.font_with_fallback({
  "JetBrainsMono NF",
  "JetBrainsMono Nerd Font",
  "CaskaydiaCove Nerd Font",
  "Cascadia Code",
  "Consolas",
})
config.font_size = 11.5
config.line_height = 1.05

-- herdr draws its own tabs and status, so WezTerm's chrome is just noise.
config.enable_tab_bar = false
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 4 }

config.scrollback_lines = 10000
config.audible_bell = "Disabled"

-- ---------------------------------------------------------------------- keys --

-- Keep this list tiny. Anything WezTerm binds is a key herdr never sees, and
-- herdr is the thing doing the multiplexing.
config.keys = {
  { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
  { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
  { key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },
  { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ShowLauncher },
  { key = "F11", mods = "", action = wezterm.action.ToggleFullScreen },
}

return config






