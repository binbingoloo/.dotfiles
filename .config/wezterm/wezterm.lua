local ok, init = pcall(require, "init")

if not ok or type(init) ~= "table" or type(init.setup) ~= "function" then
  local wezterm = require("wezterm")
  wezterm.log_error("Failed to load init.lua: " .. tostring(init))
  return {
    font_size = 11.0,
  }
end

return init.setup()
