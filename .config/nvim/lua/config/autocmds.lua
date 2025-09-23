-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Refresh buffer when external change
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Start hot reload with live-server
-- NOTE:
--  1. toggleterm.nvim required
--  2. `npm i -g live-server` needed
vim.keymap.set("n", "<M-o>", function()
  local file_path = vim.fn.expand("%:p:h") -- current file's folder
  require("toggleterm").exec("live-server " .. file_path, 1) -- opens in Terminal #1
end, { desc = "Start live-server for hot reload" })
