return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- Use thicker lines with custom colors for better visibility (like VSCode)
      signs = {
        add = { text = "▎", hl = "GitSignsAdd" },
        change = { text = "▎", hl = "GitSignsChange" },
        delete = { text = "▁", hl = "GitSignsDelete" },
        topdelete = { text = "▔", hl = "GitSignsDelete" },
        changedelete = { text = "▎", hl = "GitSignsChange" },
        untracked = { text = "▎", hl = "GitSignsUntracked" },
      },
      -- Staged signs with different colors
      signs_staged = {
        add = { text = "▎", hl = "GitSignsStagedAdd" },
        change = { text = "▎", hl = "GitSignsStagedChange" },
        delete = { text = "▁", hl = "GitSignsStagedDelete" },
        topdelete = { text = "▔", hl = "GitSignsStagedDelete" },
        changedelete = { text = "▎", hl = "GitSignsStagedChange" },
      },

      -- Enable line number highlighting for better IDE experience
      numhl = true, -- Highlight line numbers

      current_line_blame_opts = {
        delay = 500, -- Faster response
      },
      current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> • <summary>",

      -- Preview window configuration
      preview_config = {
        border = "rounded", -- Rounded border for better appearance
      },

      -- Experimental features
      trouble = false,

      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        -- Helper function to create buffer-local keymaps
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation between git changes (hunks)
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
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

        -- Blame and diff operations
        map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
        map("n", "<leader>hB", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "git [B]lame line (full)" })
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
        map("n", "<leader>hD", function()
          gitsigns.diffthis("@")
        end, { desc = "git [D]iff against last commit" })

        -- Toggle features
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
        map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
        map("n", "<leader>tl", gitsigns.toggle_linehl, { desc = "[T]oggle line high[l]ight" })
        map("n", "<leader>tn", gitsigns.toggle_numhl, { desc = "[T]oggle [n]umber highlight" })
        map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "[T]oggle [w]ord diff" })

        -- Additional operations
        map("n", "<leader>hq", gitsigns.setqflist, { desc = "git changes to [q]uickfix" })

        -- Text objects for vim motions
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner hunk" })
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "outer hunk" })
      end,
    },

    -- Configure custom highlight groups
    config = function(_, opts)
      require("gitsigns").setup(opts)

      -- Define custom colors (similar to VSCode Git colors)
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#587c0c", bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#0c7d9d", bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#94151b", bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#ff8800", bg = "NONE" })

      -- Staged signs colors (brighter)
      vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { fg = "#73c936", bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsStagedChange", { fg = "#4fc1ff", bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { fg = "#ff5555", bg = "NONE" })

      -- Line number colors
      vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#587c0c", bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#0c7d9d", bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#94151b", bg = "NONE" })

      -- Current line blame virtual text color
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#65676b", italic = true })
    end,
  },
}
