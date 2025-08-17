return {
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --  'din{' [D]elete [I]nside [N]ext [{]
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --  'sd(' [S]urround [D]elete [(]
      --      (This is the text inside) -> This is the text inside
      require("mini.surround").setup()

      -- Status line configuration
      local statusline = require("mini.statusline")
      -- use_icons determines if powerline symbols/icons are shown (requires Nerd Font)
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- Overrides the default line:column display format
      -- %2l = line number padded to 2 digits minimum
      -- :%-2v = virtual column left-aligned, 2 digits minimum
      -- Default shows percentage through file, this shows exact position
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },
}
