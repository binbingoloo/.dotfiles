local wezterm = require("wezterm")

local M = {}

function M.setup()
  local config = wezterm.config_builder and wezterm.config_builder() or {}

  require("config.options").apply(config)

  return config
end

return M
