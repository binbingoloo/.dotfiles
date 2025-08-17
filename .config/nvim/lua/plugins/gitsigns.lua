return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        -- Helper function that creates buffer-local keymaps (only active in git-tracked files)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr -- Restricts keymap to current buffer
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation between git changes (hunks)
        map("n", "]c", function()
          -- vim.wo.diff is true when in diff mode (like :Gdiffsplit)
          if vim.wo.diff then
            -- Use vim's built-in diff navigation
            vim.cmd.normal({ "]c", bang = true }) -- bang = true means use ']c!' to force the command
          else
            -- Use gitsigns navigation in normal buffers
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Jump to next git [c]hange" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Jump to previous git [c]hange" })

        -- Visual mode: stage/reset only selected lines
        map("v", "<leader>hs", function()
          -- vim.fn.line('.') = current line, vim.fn.line('v') = start of visual selection
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [s]tage hunk" })
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [r]eset hunk" })

        -- Normal mode: stage/reset entire hunk under cursor
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })

        -- Shows commit info for current line in floating window
        map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })

        -- Opens a diff view comparing current buffer with git index (staged version)
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })

        -- '@' means HEAD in git, so this compares with last committed version
        map("n", "<leader>hD", function()
          gitsigns.diffthis("@")
        end, { desc = "git [D]iff against last commit" })

        -- Toggles
        -- Shows blame info at end of each line (updates as you move cursor)
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })

        -- Shows deleted lines inline in the buffer (what was there before current changes)
        map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
