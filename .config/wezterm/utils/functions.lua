local wezterm = require("wezterm")
local action = wezterm.action
local colors = require("utils.colors")

local M = {}

-- File utilities
function M.file_exists(name)
  local file = io.open(name, "r")
  if file then
    io.close(file)
    return true
  end
  return false
end

function M.basename(path)
  return string.gsub(path, '(.*[/\\])(.*)', '%2')
end

-- Tab utilities
function M.get_tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title:gsub("^Copy mode: ", "")
end

function M.get_cwd(pane, max_width)
  local cwd = pane:get_current_working_dir()
  if not cwd then return "" end

  if type(cwd) == "userdata" then
    cwd = cwd.path
  end

  local home = os.getenv("HOME")
  if home then
    cwd = cwd:gsub("^" .. home, "~")
  end

  if max_width and #cwd > max_width then
    cwd = ".." .. cwd:sub(-(max_width - 2))
  end

  return cwd
end

-- Workspace management
function M.switch_workspace(window, pane, workspace)
  local current = window:active_workspace()
  if current == workspace then return end

  window:perform_action(action.SwitchToWorkspace({ name = workspace }), pane)
  wezterm.GLOBAL.previous_workspace = current
end

function M.switch_previous_workspace(window, pane)
  local previous = wezterm.GLOBAL.previous_workspace
  if not previous or previous == window:active_workspace() then
    return
  end
  M.switch_workspace(window, pane, previous)
end

-- Visual effects
function M.flash_screen(window)
  return
end

return M
