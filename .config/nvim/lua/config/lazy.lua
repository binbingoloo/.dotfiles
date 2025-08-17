-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- Clone lazy.nvim repository if it doesn't exist
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
    return
  end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Configure and load lazy.nvim with plugins
require("lazy").setup({
  spec = {
    -- Load all plugin specs from the 'plugins' directory
    { import = "plugins" },
  },
  -- Colorschemes for initial install
  install = { colorscheme = { "tokyonight", "habamax" } },
  -- Automatically check for plugin updates
  checker = { enabled = true },
  performance = {
    rtp = {
      -- Disable unused built-in plugins for faster startup
      disabled_plugins = {
        "gzip",
        "zipPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "netrwPlugin",
      },
    },
  },
})
