return {
  "akinsho/toggleterm.nvim",
  opts = {
    open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = {
      border = "curved",
    },
  },
  keys = {
    { "<c-\\>", desc = "Toggle terminal" },
    -- LazyGit
    {
      "<leader>tg",
      function()
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({ cmd = "lazygit", direction = "float" })
        lazygit:toggle()
      end,
      desc = "Lazygit",
    },
  },
}
