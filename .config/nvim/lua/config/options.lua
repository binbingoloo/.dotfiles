-- Display line numbers with relative numbering for easy motion commands
vim.opt.number = true
vim.opt.relativenumber = true

-- Visual aids for cursor location and sign column stability
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Hide mode indicator (redundant with statusline)
vim.opt.showmode = false

-- Keep context visible when scrolling
vim.opt.scrolloff = 10

-- Enable full mouse support
vim.opt.mouse = "a"

-- Maintain indentation on wrapped lines
vim.opt.breakindent = true

-- Persist undo history across sessions
vim.opt.undofile = true

-- Prompt before losing unsaved changes
vim.opt.confirm = true

-- Integrate with system clipboard
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Smart case-sensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Live preview for substitutions
vim.opt.inccommand = "split"

-- Show invisible characters for better formatting awareness
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

-- More intuitive window splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Faster completion and key sequence response
vim.opt.updatetime = 100
vim.opt.timeoutlen = 300

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.opt.autoread = true
