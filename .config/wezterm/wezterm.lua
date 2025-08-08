-- WezTerm Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Initialize color manager first
local colors = require("utils.colors")
colors.init()

-- Apply configurations
require("config.appearance").apply(config)
require("config.launch").apply(config)
require("config.keybindings").apply(config)
require("config.events").setup()

return config
