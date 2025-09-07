return {
  {
    "saghen/blink.cmp",
    -- Load immediately when Neovim starts (needed for completion to work from the beginning)
    event = "VimEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        -- Compiles regex support for more advanced snippet transformations
        build = (function()
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              -- Loads VSCode-style snippets into LuaSnip (provides common snippets for many languages)
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
        opts = {},
      },
      -- Provides Neovim Lua API completions when editing config files
      "folke/lazydev.nvim",
      -- TailwindCSS completions colorizer
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = {
      keymap = {
        -- 'super-tab' makes Tab key cycle through completions (Shift-Tab for previous)
        -- Other options: 'default' uses Ctrl-n/p, 'enter' confirms with Enter key
        preset = "super-tab",
      },

      appearance = {
        -- 'mono' uses monospace icons, 'normal' uses full-width icons which may misalign
        nerd_font_variant = "mono",
      },

      completion = {
        -- Prevents documentation popup from appearing automatically (can still trigger manually)
        documentation = { auto_show = false, auto_show_delay_ms = 500 },

        format = function(entry, item)
          return require("tailwindcss-colorizer-cmp").formatter(entry, item)
        end,
      },

      sources = {
        -- Order matters: LSP suggestions appear first, then file paths, snippets, and Neovim API
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          -- Higher score_offset makes lazydev suggestions appear higher when editing Neovim configs
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      -- Links blink.cmp with LuaSnip for snippet expansion
      snippets = { preset = "luasnip" },

      -- Native Lua fuzzy matching (faster than ffi implementation but slightly less accurate)
      fuzzy = { implementation = "lua" },

      -- Shows function signatures while typing arguments
      signature = { enabled = true },
    },
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    opts = {},
  },
}
