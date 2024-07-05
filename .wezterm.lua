local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- config.color_scheme = 'Sequoia Moonlight'
-- config.color_scheme = 'Catppuccin Mocha'
config.color_scheme = 'rose-pine'
config.hide_tab_bar_if_only_one_tab = true

-- please fix lol
config.enable_wayland = false

return config
