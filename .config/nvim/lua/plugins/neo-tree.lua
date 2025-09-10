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
  -- Ensures :Neotree commands are available right away
  lazy = false,
  keys = {
    { "\\", ":Neotree reveal<CR>", desc = "[R]eveal in [N]eoTree", silent = true },
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
          config = { use_float = true },
        },
      },
      width = 30,
    },

    filesystem = {
      use_libuv_file_watcher = true,

      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },

      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,

        never_show = {
          ".git",
          "node_modules",
          ".DS_Store",
          "__pycache__",
          ".cache",
        },
      },
    },
  },
}
