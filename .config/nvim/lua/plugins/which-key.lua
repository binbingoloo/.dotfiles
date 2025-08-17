return {
  {
    "folke/which-key.nvim",
    -- Loads when Neovim starts to ensure popup help is available for all keymaps
    event = "VimEnter",
    opts = {
      -- Shows popup immediately when pressing leader key (default is 300ms)
      -- Set to 0 for instant feedback when you're learning keybindings
      delay = 0,
      icons = {
        -- Shows icons next to commands in the popup (like  for search,  for git)
        mappings = vim.g.have_nerd_font,
        -- Only configures key icons if Nerd Font is available
        -- Empty {} uses default icon set, set to false to disable key icons
        keys = vim.g.have_nerd_font and {},
      },

      -- Defines keymap groups that appear in the which-key popup
      -- These create labeled sections when you press the prefix key
      spec = {
        -- When you press <leader>s, shows all search-related commands
        { "<leader>s", group = "[S]earch" },
        -- When you press <leader>t, shows all toggle commands
        { "<leader>t", group = "[T]oggle" },
        -- Git hunk operations available in both normal and visual mode
        -- Visual mode allows operating on selected lines only
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      },
    },
  },
}
