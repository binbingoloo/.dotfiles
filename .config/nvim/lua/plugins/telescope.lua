return {
  {
    "nvim-telescope/telescope.nvim",
    -- Loads when Neovim starts to ensure keymaps are available immediately
    event = "VimEnter",
    dependencies = {
      -- Required dependency that provides many lua functions Telescope uses internally
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- Compiles a C implementation of FZF algorithm for 10-100x faster sorting performance
        -- Without this, Telescope uses a slower lua implementation
        build = "make",
        -- Only attempts to install if 'make' command exists
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      -- Makes vim.ui.select (used by LSP rename, code actions) use Telescope's interface
      -- instead of Neovim's basic input prompt
      { "nvim-telescope/telescope-ui-select.nvim" },
      -- File type icons in Telescope results (requires a Nerd Font to display properly)
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "^.git/",
            "^node_modules/",
            "%.lock$",
            "^dist/",
            "^target/",
            "^build/",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = true,
          },
          live_grep = {
            additional_args = function()
              return {
                "--hidden",
                "--no-ignore",
                "--glob=!.git/*",
                "--glob=!node_modules/*",
              }
            end,
          },
          grep_string = {
            additional_args = function()
              return {
                "--hidden",
                "--no-ignore",
                "--glob=!.git/*",
                "--glob=!node_modules/*",
              }
            end,
          },
        },
        extensions = {
          ["ui-select"] = {
            -- get_dropdown creates a centered floating window with no preview
            -- Other themes:
            --    get_cursor  (at cursor position)
            --    get_ivy     (bottom of screen)
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- This allows the config to work even if you remove the extension dependencies
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")

      -- Search through vim's help documentation by tags
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

      -- Shows all current keymaps and lets you search/execute them
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })

      -- Find files in current directory (respects .gitignore if in git repo)
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })

      -- Shows all available Telescope pickers (like a Telescope command palette)
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })

      -- Searches for the word under cursor across all files (like * but project-wide)
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })

      -- Live grep lets you type and see results update in real-time across all files
      -- Requires 'ripgrep' (rg) to be installed on your system
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })

      -- Shows all LSP diagnostics (errors, warnings) in current workspace
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })

      -- Reopens the last Telescope picker with previous search query
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })

      -- Shows recently opened files (from vim.v.oldfiles)
      -- The "." mnemonic: like hitting '.' to repeat last action
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

      -- Quick buffer switcher - shows all open buffers
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      -- Fuzzy search within current buffer only (like / search but with fuzzy matching)
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          -- 10% window transparent
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- Live grep but only searches within currently open buffers
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          -- Restricts search to open buffers only
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Quick access to search Neovim config files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },
}
