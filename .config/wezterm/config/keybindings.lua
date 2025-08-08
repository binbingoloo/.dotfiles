local wezterm = require("wezterm")
local action = wezterm.action
local functions = require("utils.functions")
local colors = require("utils.colors")

local M = {}

-- Configuration
local TIMEOUT = { key = 3000, leader = 1500 }

function M.apply(config)
  config.disable_default_key_bindings = true
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = TIMEOUT.leader }
  config.keys = M.get_keys()
  config.key_tables = M.get_key_tables()
end

function M.get_keys()
  local keys = {
    -- Key table modes
    { key = "o", mods = "LEADER", action = M.activate_table("open") },
    { key = "m", mods = "LEADER", action = M.activate_table("move") },
    { key = "r", mods = "LEADER", action = M.activate_table("resize") },
    { key = "y", mods = "LEADER", action = M.activate_table("copy") },

    -- Application
    { key = "q", mods = "CMD", action = action.QuitApplication },
    { key = "k", mods = "CMD", action = action.Multiple {
        action.ClearScrollback "ScrollbackAndViewport",
        action.SendKey { key = "l", mods = "CTRL" },
        action.EmitEvent "flash-terminal"
      }
    },

    -- Clipboard
    { key = "v", mods = "CMD", action = action.PasteFrom("Clipboard") },
    { key = "c", mods = "CMD", action = action.Multiple {
        action.CopyTo("ClipboardAndPrimarySelection"),
        action.ClearSelection
      }
    },

    -- Tab management
    { key = "t", mods = "CMD", action = action.SpawnTab("DefaultDomain") },
    { key = "w", mods = "CMD", action = action.CloseCurrentPane { confirm = false } },
    { key = "t", mods = "LEADER", action = action.ShowLauncherArgs { flags = "TABS" } },

    -- Workspace
    { key = "l", mods = "LEADER", action = wezterm.action_callback(function(window, pane)
        functions.switch_previous_workspace(window, pane)
        window:perform_action(action.EmitEvent "set-previous-workspace", pane)
      end)
    },
    { key = "s", mods = "LEADER", action = action.Multiple {
        action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" },
        action.EmitEvent "set-previous-workspace"
      }
    },

    -- Pane operations
    { key = "-", mods = "LEADER", action = action.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "\\", mods = "LEADER", action = action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "z", mods = "LEADER", action = action.TogglePaneZoomState },

    -- Navigation
    { key = "LeftArrow", mods = "OPT", action = action.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "OPT", action = action.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "OPT", action = action.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "OPT", action = action.ActivatePaneDirection("Down") },

    -- Scrolling
    -- Line-by-line scrolling
    { key = "UpArrow", mods = "SHIFT", action = action.ScrollByLine(-1) },
    { key = "DownArrow", mods = "SHIFT", action = action.ScrollByLine(1) },
    -- Full page scrolling
    { key = "UpArrow", mods = "CMD|SHIFT", action = action.ScrollByPage(-1) },
    { key = "DownArrow", mods = "CMD|SHIFT", action = action.ScrollByPage(1) },
    -- Half page scrolling
    { key = "UpArrow", mods = "CMD|OPT", action = action.ScrollByPage(-0.5) },
    { key = "DownArrow", mods = "CMD|OPT", action = action.ScrollByPage(0.5) },
    -- Jump to top/bottom
    { key = "UpArrow", mods = "CMD", action = action.ScrollToTop },
    { key = "DownArrow", mods = "CMD", action = action.ScrollToBottom },

    -- Font size
    { key = "0", mods = "CMD", action = action.ResetFontSize },
    { key = "-", mods = "CMD", action = action.DecreaseFontSize },
    { key = "=", mods = "CMD", action = action.IncreaseFontSize },

    -- Tab navigation
    { key = "[", mods = "CMD|SHIFT", action = action.ActivateTabRelative(-1) },
    { key = "]", mods = "CMD|SHIFT", action = action.ActivateTabRelative(1) },

    -- Workspace navigation
    { key = "[", mods = "CMD|OPT", action = action.Multiple {
        action.SwitchWorkspaceRelative(-1), action.EmitEvent "set-previous-workspace" }
    },
    { key = "]", mods = "CMD|OPT", action = action.Multiple {
        action.SwitchWorkspaceRelative(1), action.EmitEvent "set-previous-workspace" }
    },

    -- Utility
    { key = "/", mods = "CMD", action = action.Search { CaseInSensitiveString = "" } },
    { key = "c", mods = "LEADER", action = action.ShowLauncherArgs { flags = "FUZZY|LAUNCH_MENU_ITEMS" } },
    -- { key = "d", mods = "LEADER", action = action.ShowDebugOverlay },
    { key = "h", mods = "LEADER", action = action.ActivateCommandPalette },
    { key = "v", mods = "LEADER", action = action.ActivateCopyMode },

    -- Rename
    { key = ",", mods = "LEADER", action = M.rename_tab_prompt() },
    { key = "$", mods = "LEADER|SHIFT", action = M.rename_workspace_prompt() },

    -- Help
    {
      key = "?",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        local home = os.getenv("HOME")
        local cheatsheets_dir = home .. "/.config/wezterm/cheatsheets"

        local choices = {}
        local handle = io.popen('ls -1 ' .. cheatsheets_dir .. ' 2>/dev/null')
        if handle then
          for file in handle:lines() do
            table.insert(choices, {
              label = file,
              id = file,
            })
          end
          handle:close()
        end

        window:perform_action(
          wezterm.action.InputSelector {
            title = "Select Cheatsheet",
            choices = choices,
            fuzzy = true,
            action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
              if id then
                inner_window:perform_action(
                  wezterm.action.SpawnCommandInNewWindow {
                    args = { 'zsh', '-lc', 'bat --paging=always ~/.config/wezterm/cheatsheets/' .. id }
                  },
                  inner_pane
                )
              end
            end),
          },
          pane
        )
      end),
    }
  }

  -- Number keys for tab activation
  for i = 1, 9 do
    table.insert(keys, { key = tostring(i), mods = "CMD", action = action.ActivateTab(i - 1) })
  end

  return keys
end

function M.get_key_tables()
  return {
    copy = {
      { key = "b", action = action.EmitEvent "copy-buffer-from-pane" },
      { key = "p", action = action.EmitEvent "copy-text-from-pane" },
      { key = "l", action = M.copy_line_action() },
      { key = "r", action = M.copy_regex_action() },
    },

    move = {
      { key = "r", action = action.RotatePanes 'CounterClockwise' },
      { key = "s", action = action.PaneSelect },
      { key = "Enter", action = "PopKeyTable" },
      { key = "Escape", action = "PopKeyTable" },
      { key = "LeftArrow", mods = "SHIFT", action = action.MoveTabRelative(-1) },
      { key = "RightArrow", mods = "SHIFT", action = action.MoveTabRelative(1) },
    },

    resize = {
      { key = "DownArrow", action = action.AdjustPaneSize { "Down", 1 } },
      { key = "LeftArrow", action = action.AdjustPaneSize { "Left", 1 } },
      { key = "RightArrow", action = action.AdjustPaneSize { "Right", 1 } },
      { key = "UpArrow", action = action.AdjustPaneSize { "Up", 1 } },
      { key = "Enter", action = "PopKeyTable" },
      { key = "Escape", action = "PopKeyTable" },
    },

    open = {
      { key = "p", action = M.spawn_command("Finder", { "open", "." }) },
      { key = "c", action = M.spawn_command("VS Code", { "zsh", "-lc", "code ." }) },
      { key = "u", action = M.open_url_action() },
    }
  }
end

-- Helper functions
function M.activate_table(name)
  return action.ActivateKeyTable {
    name = name,
    one_shot = false,
    until_unknown = name ~= "move",
    timeout_milliseconds = TIMEOUT.key
  }
end

function M.spawn_command(label, args)
  return action.SpawnCommandInNewWindow { label = label, args = args }
end

function M.copy_line_action()
  return action.QuickSelectArgs {
    label = "COPY LINE",
    patterns = { "^.*\\S+.*$" },
    scope_lines = 1,
    action = action.Multiple {
      action.CopyTo("ClipboardAndPrimarySelection"),
      action.ClearSelection
    }
  }
end

function M.copy_regex_action()
  return action.QuickSelectArgs {
    label = "COPY REGEX",
    patterns = {
      "(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(?:/\\d{1,2})?)",
      "((?:[[:xdigit:]]{0,4}:){2,7}[[:xdigit:]]{0,4}(?:/\\d{1,3})?)",
      "[[:xdigit:]]{2}:[[:xdigit:]]{2}:[[:xdigit:]]{2}:[[:xdigit:]]{2}:[[:xdigit:]]{2}:[[:xdigit:]]{2}",
      "\\S+@\\S+\\.\\S+",
      "[[:xdigit:]]{12}",
      "\\S+/\\S+:\\S+",
      "[[:xdigit:]]{7,}",
      "(?:https?|s?ftp)://\\S+"
    },
    action = action.Multiple {
      action.CopyTo("ClipboardAndPrimarySelection"),
      action.ClearSelection
    }
  }
end

function M.open_url_action()
  return action.QuickSelectArgs {
    label = "Open URL",
    patterns = { "https?://\\S+" },
    scope_lines = 30,
    action = wezterm.action_callback(function(window, pane)
      local url = window:get_selection_text_for_pane(pane)
      wezterm.open_with(url)
    end)
  }
end

function M.rename_tab_prompt()
  return action.PromptInputLine {
    description = wezterm.format {
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { Color = colors.fg() } },
      { Text = "Rename tab:" }
    },
    action = wezterm.action_callback(function(window, _, line)
      if line then window:active_tab():set_title(line) end
    end),
  }
end

function M.rename_workspace_prompt()
  return action.PromptInputLine {
    description = wezterm.format {
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { Color = colors.fg() } },
      { Text = "Rename workspace:" }
    },
    action = wezterm.action_callback(function(_, _, line)
      if line then
        local mux = wezterm.mux
        mux.rename_workspace(mux.get_active_workspace(), line)
      end
    end),
  }
end

return M
