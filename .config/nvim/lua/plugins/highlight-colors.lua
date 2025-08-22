return {
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual", -- or 'foreground' or 'virtual'
        virtual_symbol_prefix = " ",
        virtual_symbol = "",
        virtual_symbol_position = "eow",
        enable_tailwind = true,
      })
    end,
  },
}
