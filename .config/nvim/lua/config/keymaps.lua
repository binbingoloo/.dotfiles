-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "[C]lear [H]ighlights" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "[E]xit [T]erminal mode" })

-- Disable arrow keys
vim.keymap.set("n", "<left>", '<cmd>echo "← Hint: h moves left"<CR>', { desc = "[D]isable [L]eft arrow" })
vim.keymap.set("n", "<right>", '<cmd>echo "→ Hint: l moves right"<CR>', { desc = "[D]isable [R]ight arrow" })
vim.keymap.set("n", "<up>", '<cmd>echo "↑ Hint: k moves up"<CR>', { desc = "[D]isable [U]p arrow" })
vim.keymap.set("n", "<down>", '<cmd>echo "↓ Hint: j moves down"<CR>', { desc = "[D]isable [D]own arrow" })

-- Navigate between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "[F]ocus [L]eft window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "[F]ocus [R]ight window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "[F]ocus [L]ower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "[F]ocus [U]pper window" })

-- Rearrange window layout on the fly
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "[M]ove window [L]eft" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "[M]ove window [R]ight" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "[M]ove window [D]own" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "[M]ove window [U]p" })

-- Allow continuous indentation in visual mode without exiting visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and maintain visual selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and maintain visual selection" })

-- Make normal mode indentation repeatable without requiring re-entry of commands
vim.keymap.set("n", ">", ">>", { desc = "Indent line right" })
vim.keymap.set("n", "<", "<<", { desc = "Indent line left" })

-- Continuous window resizing with Alt+arrow keys
vim.keymap.set("n", "<M-h>", "<C-w>>", { desc = "Push border left (increase width)" })
vim.keymap.set("n", "<M-l>", "<C-w><", { desc = "Push border right (decrease width)" })
vim.keymap.set("n", "<M-j>", "<C-w>+", { desc = "Push border down (increase height)" })
vim.keymap.set("n", "<M-k>", "<C-w>-", { desc = "Push border up (decrease height)" })
