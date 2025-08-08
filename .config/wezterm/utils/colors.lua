local wezterm = require("wezterm")

local M = {}

-- Theme configuration
local themes = {
  dark = "Catppuccin Frappe",
  light = "Catppuccin Mocha",
}

-- Color cache
local color_cache = {}

function M.init()
  local appearance = wezterm.gui.get_appearance()
  local scheme_name = appearance:find("Dark") and themes.dark or themes.light

  local scheme = wezterm.get_builtin_color_schemes()[scheme_name]
  if scheme then
    color_cache = scheme
    color_cache.scheme_name = scheme_name
  end
end

function M.get(key, fallback)
  if color_cache[key] then
    return color_cache[key]
  elseif color_cache.ansi and color_cache.ansi[key] then
    return color_cache.ansi[key]
  elseif color_cache.indexed and color_cache.indexed[key] then
    return color_cache.indexed[key]
  end
  return fallback or "#ffffff"
end

function M.get_scheme_name()
  return color_cache.scheme_name or themes.dark
end

function M.get_all()
  return color_cache
end

-- Quick color accessors
function M.bg() return M.get("background", "#303446") end
function M.fg() return M.get("foreground", "#c6d0f5") end
function M.cursor() return M.get(16, "#c6d0f5") end
function M.red() return M.get(1, "#e78284") end
function M.green() return M.get(2, "#a6e3a1") end
function M.yellow() return M.get(3, "#f5c2e7") end
function M.blue() return M.get(4, "#89b4fa") end
function M.magenta() return M.get(5, "#ca9ee6") end
function M.cyan() return M.get(6, "#94e2d5") end
function M.white() return M.get(7, "#f4b8e4") end
function M.bright_black() return M.get(8, "#a5adce") end

return M
