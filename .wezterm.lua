local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- config.color_scheme = 'Sequoia Moonlight'
-- config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = 'rose-pine'
config.color_scheme = 'GruvboxDarkHard'
config.freetype_load_target = "Light"

local gpus = wezterm.gui.enumerate_gpus()
config.webgpu_preferred_adapter = gpus[1]
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- config.tab_bar_style = {
--   active_tab_left = wezterm.format {
--     { Background = { Color = '#0b0022' } },
--     { Foreground = { Color = '#2b2042' } },
--     { Text = SOLID_LEFT_ARROW },
--   },
--   active_tab_right = wezterm.format {
--     { Background = { Color = '#0b0022' } },
--     { Foreground = { Color = '#2b2042' } },
--     { Text = SOLID_RIGHT_ARROW },
--   },
--   inactive_tab_left = wezterm.format {
--     { Background = { Color = '#0b0022' } },
--     { Foreground = { Color = '#1b1032' } },
--     { Text = SOLID_LEFT_ARROW },
--   },
--   inactive_tab_right = wezterm.format {
--     { Background = { Color = '#0b0022' } },
--     { Foreground = { Color = '#1b1032' } },
--     { Text = SOLID_RIGHT_ARROW },
--   },
-- }
config.hide_tab_bar_if_only_one_tab = true


-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'z',
    mods = 'LEADER|CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = 'D',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DetachDomain 'CurrentPaneDomain',
  },
  {
    key = 'H',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'J',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },
  { key = 'K', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  {
    key = 'L',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
}

-- please fix lol
config.enable_wayland = true

return config
