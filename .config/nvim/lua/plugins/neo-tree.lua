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
    default_component_configs = {
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "󰜌",
      },
      git_status = {
        symbols = {
          added = "✚",
          modified = "", -- or ""
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },

    window = {
      mappings = {
        -- Pressing \ inside neo-tree closes it
        ["\\"] = "close_window",
        ["E"] = "expand_all_nodes",
        ["W"] = "close_all_nodes",
        ["<space>"] = {
          "toggle_preview",
          nowait = true,
          config = { use_float = false },
        },
      },
    },

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
    },
  },
}
