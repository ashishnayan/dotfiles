-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
-- config.color_scheme = 'Batman'
config.color_scheme = 'catppuccin-macchiato'

-- config.font = wezterm.font 'FiraCode Nerd Font'
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })
-- config.font = wezterm.font 'Source Code Pro'
config.font = wezterm.font 'SauceCodePro Nerd Font'
config.font = wezterm.font('SauceCodePro Nerd Font', { weight = 'Light' })
-- config.font = wezterm.font('SauceCodePro Nerd Font', { weight = 'Medium', italic = true })
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })
-- and finally, return the configuration to wezterm

config.font_size = 17
config.bold_brightens_ansi_colors = true
-- config.line_height = 1


-- config.term = 'alacritty'
-- config.term = 'wezterm'
config.enable_tab_bar = false
config.force_reverse_video_cursor = true
config.window_padding = {
  left = "0.5cell",
  right = "0.1cell",
  top = "0.1cell",
  bottom = "0.1cell",
}
return config
