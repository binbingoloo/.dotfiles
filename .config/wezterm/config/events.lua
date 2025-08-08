local wezterm = require("wezterm")
local nerdfonts = wezterm.nerdfonts
local functions = require("utils.functions")
local workspaces = require("utils.workspaces")
local statusbar = require("utils.statusbar")
local colors = require("utils.colors")

local M = {}

-- Program icons mapping
local PROGRAM_ICONS = {
  docker = nerdfonts.linux_docker,
  podman = nerdfonts.linux_docker,
  kind = nerdfonts.md_kubernetes,
  kubectl = nerdfonts.md_kubernetes,
  ssh = nerdfonts.md_remote_desktop,
  vim = nerdfonts.dev_vim,
  nvim = nerdfonts.dev_vim,
  vi = nerdfonts.dev_vim,
  watch = nerdfonts.md_eye_outline,
}

function M.setup()
  wezterm.on("update-status", M.update_status)
  wezterm.on("format-tab-title", M.format_tab_title)
  wezterm.on("gui-startup", M.gui_startup)

  -- Copy operations
  wezterm.on("copy-buffer-from-pane", M.copy_buffer)
  wezterm.on("copy-text-from-pane", M.copy_text)
  wezterm.on("flash-terminal", function(window) functions.flash_screen(window) end)

  -- Workspace management
  wezterm.on("set-previous-workspace", M.set_previous_workspace)
  wezterm.on('window-focus-changed', M.window_focus_changed)
end

function M.update_status(window, pane)
  local active_key_table = window:active_key_table()
  local workspace = window:active_workspace()
  local workspace_color = colors.yellow()

  -- Determine status and color
  if active_key_table then
    workspace = active_key_table
    workspace_color = colors.blue()
  elseif window:leader_is_active() then
    workspace = "leader"
    workspace_color = colors.green()
  end

  -- Get system info
  local cwd = functions.get_cwd(pane, 35)
  local username = os.getenv("USER") or "user"
  local hostname = wezterm.hostname() or "localhost"
  local time = wezterm.strftime("%H:%M")

  -- Set status bars
  window:set_left_status(statusbar.create_left_status(workspace, workspace_color))
  window:set_right_status(statusbar.create_right_status(cwd, username, hostname, time))
end

function M.format_tab_title(tab)
  local pane = tab.active_pane
  local title = functions.get_tab_title(tab)
  local tab_number = tostring(tab.tab_index + 1)
  -- local program = pane.user_vars.WEZTERM_PROG
  local program = title

  -- Process title
  if #title > 30 then
    title = title:sub(1, 27) .. "..."
  end

  -- Add status icons
  if pane.is_zoomed then
    title = nerdfonts.cod_zoom_in .. " " .. title
  end

  if title:match("^Copy mode:") then
    title = nerdfonts.md_content_copy .. " " .. title
  end

  -- Add program icon
  if program and program ~= "" then
    local command = program:match("^%S+")
      local icon = PROGRAM_ICONS[command]
    if not icon and command and command:match("^[bh]?top") then
        icon = nerdfonts.md_monitor_eye
      end
      title = (icon or nerdfonts.dev_terminal) .. " " .. title
  end

  -- Check for unseen output
  if not tab.is_active then
    for _, p in ipairs(tab.panes) do
      if p.has_unseen_output then
        title = nerdfonts.md_bell_ring_outline .. " " .. title
        break
      end
    end
  end

  -- Format tab
  if tab.is_active then
    return {
      { Background = { Color = colors.bg() } },
      { Foreground = { Color = colors.cursor() } },
      { Text = title .. " " },
      { Background = { Color = colors.cursor() } },
      { Foreground = { Color = colors.bg() } },
      { Text = " " .. tab_number },
      { Background = { Color = colors.bg() } },
      { Foreground = { Color = colors.cursor() } },
      { Text = nerdfonts.ple_right_half_circle_thick .. " " },
    }
  else
    return {
      { Background = { Color = colors.bg() } },
      { Foreground = { Color = colors.red() } },
      { Text = nerdfonts.ple_left_half_circle_thick },
      { Background = { Color = colors.red() } },
      { Foreground = { Color = colors.fg() } },
      { Text = title .. " " },
      { Background = { Color = colors.magenta() } },
      { Foreground = { Color = colors.bg() } },
      { Text = " " .. tab_number },
      { Background = { Color = colors.bg() } },
      { Foreground = { Color = colors.magenta() } },
      { Text = nerdfonts.ple_right_half_circle_thick .. " " },
    }
  end
end

function M.gui_startup()
  local mux = wezterm.mux

  for _, space in pairs(workspaces.config.spaces) do
    local _, _, window = mux.spawn_window({
      workspace = space.name,
      cwd = space.path
    })

    if space.tabs then
      window:active_tab():set_title(space.tabs[1])
      for i = 2, #space.tabs do
        local tab = window:spawn_tab({ cwd = space.path .. "/" .. space.tabs[i] })
        tab:set_title(space.tabs[i])
      end
    end
  end

  mux.set_active_workspace(workspaces.config.default)
end

function M.copy_buffer(window, pane)
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
  window:copy_to_clipboard(text)
  functions.flash_screen(window)
end

function M.copy_text(window, pane)
  local text = pane:get_lines_as_text(pane:get_dimensions().viewport_rows)
  window:copy_to_clipboard(text)
  functions.flash_screen(window)
end

function M.set_previous_workspace(window)
  local current = window:active_workspace()
  if wezterm.GLOBAL.previous_workspace ~= current then
    wezterm.GLOBAL.previous_workspace = current
  end
end

function M.window_focus_changed(window)
  local overrides = window:get_config_overrides() or {}

  if window:is_focused() then
    overrides.foreground_text_hsb = { brightness = 1.0, hue = 1.0, saturation = 1.0 }
    overrides.inactive_pane_hsb = { brightness = 0.6, hue = 1.0, saturation = 0.6 }
  else
    overrides.foreground_text_hsb = { brightness = 0.6, hue = 1.0, saturation = 0.6 }
    overrides.inactive_pane_hsb = { brightness = 1.0, hue = 1.0, saturation = 1.0 }
  end

  window:set_config_overrides(overrides)
end

return M
