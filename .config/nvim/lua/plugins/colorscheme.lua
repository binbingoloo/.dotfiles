return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        background = {
          light = "latte",
          dark = "mocha",
        },
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
        },
        color_overrides = {
          latte = {
            -- macOS-like white background
            base = "#ffffff",
            mantle = "#f5f5f5",
            crust = "#ebebeb",
          },
        },
        custom_highlights = function(colors)
          return {
            -- Make neo-tree current file more visible
            NeoTreeCursorLine = { bg = colors.surface1, style = { "bold" } },
            NeoTreeFileNameOpened = { fg = colors.blue, style = { "bold" } },

            -- Better search highlighting
            IncSearch = { bg = colors.peach, fg = colors.base },
            Search = { bg = colors.sky, fg = colors.base },
          }
        end,
        integrations = {
          nvimtree = false,
          telescope = {
            style = "nvchad",
          },
          mini = {
            indentscope_color = "lavender",
          },
          indent_blankline = {
            scope_color = "lavender",
          },
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
