-- WezTerm on macOS. Ported from windows/wezterm.lua in the dotfiles repo.
-- Opens straight into herdr, so every session starts inside the multiplexer
-- instead of a bare shell.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ---------------------------------------------------------------- what runs --

-- Land in herdr, through a login shell. Named by shell rather than by path to
-- herdr on purpose: brew puts it in /opt/homebrew/bin and nix puts it in
-- ~/.nix-profile/bin, and a login zsh has sourced whichever is active. exec
-- replaces the shell, so closing herdr closes the window.
config.default_prog = { "/bin/zsh", "-lic", "exec herdr" }

-- Every window starts in the repo, matching herdr's own new_cwd.
config.default_cwd = wezterm.home_dir .. "/github/dotfiles"

-- A plain shell, for when herdr itself is the thing you need to fix.
config.launch_menu = {
  { label = "zsh (no herdr)", args = { "/bin/zsh", "-l" } },
}

-- ------------------------------------------------------------------- colors --

-- Rose Pine Moon, written out rather than referenced by name so it renders the
-- same on any WezTerm version. Matches the nvim colorscheme.
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

-- macos_window_background_blur is the Mac equivalent of win32's Acrylic.
config.window_background_opacity = 0.80
config.macos_window_background_blur = 30
-- herdr paints its own panels, status bar and pane backgrounds; at 1.0 those
-- render as solid blocks over the blur. Low value lets the whole window read
-- as one frosted sheet.
config.text_background_opacity = 0.2

config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.7 }

-- --------------------------------------------------------------------- look --

-- "JetBrainsMono NF" is the patched Nerd Font build and is what the Windows
-- side has. This Mac installs the plain family plus the symbols-only Nerd Font,
-- so the patched name is not here and asking for it first threw a font error
-- dialog on every launch. Plain family first, symbols as the icon fallback.
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Symbols Nerd Font Mono",
  "Menlo",
})
config.font_size = 14.0
config.line_height = 1.05

-- herdr draws its own tabs and status, so WezTerm's chrome is just noise.
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 4 }

config.scrollback_lines = 10000
config.audible_bell = "Disabled"

-- macOS: left Option must be Alt, or none of herdr's ctrl+alt bindings arrive.
-- Right Option still types accented characters.
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- ---------------------------------------------------------------------- keys --

-- Keep this list tiny. Anything WezTerm binds is a key herdr never sees, and
-- herdr is the thing doing the multiplexing. Cmd+C / Cmd+V are native on macOS
-- and cost herdr nothing, so they are not listed here.
config.keys = {
  { key = "n", mods = "CMD|SHIFT", action = wezterm.action.SpawnWindow },
  { key = "l", mods = "CMD|SHIFT", action = wezterm.action.ShowLauncher },
  { key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },
}

return config
