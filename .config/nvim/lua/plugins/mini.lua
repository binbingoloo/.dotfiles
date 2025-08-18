return {
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --  'din{' [D]elete [I]nside [N]ext [{]
      --  'dan{' [D]elete [A]rround [N]ext [{]
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --  'sd(' [S]urround [D]elete [(]
      --      (This is the text inside) -> This is the text inside
      require("mini.surround").setup()
    end,
  },
}
