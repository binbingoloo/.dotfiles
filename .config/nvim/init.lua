-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Font support for better icons and symbols
vim.g.have_nerd_font = true

-- Load Neovim options configuration (line numbers, tabs, search behavior...)
require("config.options")

-- Initialize lazy.nvim plugin manager and load all plugins
require("config.lazy")

-- Load automatic commands (autocommands)
require("config.autocmds")

-- Load custom keyboard shortcuts and mappings
require("config.keymaps")
