return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      triggers = {
        { "<leader>", mode = { "n", "v" } },
        { "<localleader>", mode = { "n", "v" } },
        { "g", mode = { "n", "v" } },
      },

      -- Shows popup  when pressing leader key (default is 300ms)
      delay = 150,
      icons = {
        -- Shows icons next to commands in the popup
        mappings = vim.g.have_nerd_font,
        -- Only configures key icons if Nerd Font is available
        -- Empty {} uses default icon set, set to false to disable key icons
        keys = vim.g.have_nerd_font and {},
      },

      -- Defines keymap groups that appear in the which-key popup
      spec = {
        { "<leader>s", group = "[S]earch", icon = "🔍" },
        { "<leader>t", group = "[T]oggle", icon = "🔄" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" }, icon = "🌿" },
        { "<leader>b", group = "[B]uffer", icon = "📁" },
        { "<leader>d", group = "[D]ebug", icon = "🐛" },
        { "<leader>w", group = "[W]rite", icon = "💾" },

        { "g", group = "+goto", mode = { "n", "v" }, icon = "🚀" },
        { "<leader>c", group = "[C]ode", icon = "🔧" },
        { "<leader>r", group = "[R]efactor", icon = "♻️" },

        { "<leader>1", hidden = true },
        { "<leader>2", hidden = true },
        { "<leader>3", hidden = true },
        { "<leader>4", hidden = true },
        { "<leader>5", hidden = true },
        { "<leader>6", hidden = true },
        { "<leader>7", hidden = true },
        { "<leader>8", hidden = true },
        { "<leader>9", hidden = true },
        { "<leader>$", hidden = true },
        { "<leader>f", hidden = true },
      },
    },
  },
}
