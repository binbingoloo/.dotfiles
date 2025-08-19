local wezterm = require("wezterm")
local colors = require("utils.colors")

local M = {}

function M.apply(config)
  -- Color scheme
  config.color_scheme = colors.get_scheme_name()

  -- Custom colors
  config.colors = {
    compose_cursor = colors.green(),
    cursor_bg = colors.cursor(),
    cursor_border = colors.cursor(),
    split = colors.cursor(),
    tab_bar = {
      background = colors.bg(),
      active_tab = {
        bg_color = colors.bg(),
        fg_color = colors.cursor(),
        italic = true,
      },
    },
    visual_bell = colors.red(),
  }

  -- Font configuration
  config.font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    "SF Mono",
    "Apple Color Emoji",
  })
  config.font_size = 11.0
  config.line_height = 1.2

  -- Window appearance
  config.window_frame = {
    border_left_width = "0cell",
    border_right_width = "0cell",
    border_bottom_height = "0cell",
    border_top_height = "0.35cell",
    border_left_color = colors.bg(),
    border_right_color = colors.bg(),
    border_bottom_color = colors.bg(),
    border_top_color = colors.bg(),
  }

  config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
  config.window_padding = { left = 5, right = 5, top = 5, bottom = 0 }

  -- Transparency and effects
  config.text_background_opacity = 0.95
  config.window_background_opacity = 0.95

  config.visual_bell = {
    fade_in_function = "Constant",
    fade_in_duration_ms = 0,
    fade_out_function = "Constant",
    fade_out_duration_ms = 300,
    target = "CursorColor",
  }

  config.inactive_pane_hsb = { brightness = 0.6, hue = 1.0, saturation = 0.6 }

  -- Cursor
  config.cursor_blink_ease_in = "Constant"
  config.cursor_blink_ease_out = "Constant"
  config.cursor_blink_rate = 700
  config.default_cursor_style = "BlinkingBlock"
  config.force_reverse_video_cursor = false
  config.hide_mouse_cursor_when_typing = true

  -- Tab bar
  config.enable_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false
  config.show_new_tab_button_in_tab_bar = false
  config.show_tab_index_in_tab_bar = true
  config.status_update_interval = 1000
  config.tab_bar_at_bottom = false
  config.tab_max_width = 35
  config.use_fancy_tab_bar = false

  -- Performance
  config.animation_fps = 60
  config.front_end = "WebGpu"
  config.max_fps = 120
  config.webgpu_power_preference = "HighPerformance"
end

return M
