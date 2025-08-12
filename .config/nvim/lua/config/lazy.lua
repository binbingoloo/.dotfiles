-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- Clone lazy.nvim if not installed
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Failed to clone lazy.nvim:\n' .. out)
    return
  end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim
require('lazy').setup({

})
