return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    -- Utility functions used internally by neo-tree
    "nvim-lua/plenary.nvim",
    -- File type icons (requires Nerd Font)
    "nvim-tree/nvim-web-devicons",
    -- UI component library for floating windows
    "MunifTanjim/nui.nvim",
  },
  -- Load immediately on startup to register commands (even though we open it with keymap)
  -- This ensures :Neotree commands are available right away
  lazy = false,
  keys = {
    -- "reveal" opens neo-tree and highlights the current file (shows where you are)
    -- Better than just "open" which doesn't navigate to current file location
    { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,

        never_show = {
          ".git",
          "node_modules",
          ".DS_Store",
          "__pycache__",
        },
      },
      window = {
        mappings = {
          -- Same key to toggle: pressing \ inside neo-tree closes it
          -- Creates a toggle behavior - one key to open and close
          ["\\"] = "close_window",
        },
      },
    },
  },
}
