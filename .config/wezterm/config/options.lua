local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  -- Basic settings
  config.default_prog = { "/bin/zsh", "-l" }

  config.automatically_reload_config = true
  config.initial_cols = 160
  config.initial_rows = 35

  -- Font Configuration
  config.font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
  })
  config.font_size = 11
  config.line_height = 1.2
end

return M
