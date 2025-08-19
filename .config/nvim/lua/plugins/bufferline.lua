return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "echasnovski/mini.bufremove",
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    keys = {
      -- Switch between buffers
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "[G]o to [P]revious Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "[G]o to [N]ext Buffer" },
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "[G]o to [N]ext Buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "[G]o to [P]revious Buffer" },

      -- Buffer management
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "[T]oggle [P]in Buffer" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "[C]lose [O]ther Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "[C]lose Buffers to [R]ight" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "[C]lose Buffers to [L]eft" },
      { "<leader>bs", "<cmd>BufferLinePick<cr>", desc = "[S]elect [B]uffer" },
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "[P]ick [C]lose Buffer" },

      -- Quick jump to buffer by number
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "[G]o to Buffer [1]" },
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "[G]o to Buffer [2]" },
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "[G]o to Buffer [3]" },
      { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "[G]o to Buffer [4]" },
      { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "[G]o to Buffer [5]" },
      { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "[G]o to Buffer [6]" },
      { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "[G]o to Buffer [7]" },
      { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "[G]o to Buffer [8]" },
      { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "[G]o to Buffer [9]" },
      { "<leader>$", "<cmd>BufferLineGoToBuffer -1<cr>", desc = "[G]o to [L]ast Buffer" },

      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0)
        end,
        desc = "[D]elete [B]uffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "[D]elete [B]uffer (Force)",
      },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        close_command = function(n)
          require("mini.bufremove").delete(n)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  {
    "echasnovski/mini.bufremove",
    config = function()
      require("mini.bufremove").setup()

      -- Override default :q command behavior
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("bufremove_override_q", { clear = true }),
        nested = true,
        callback = function()
          -- Only override :q when there are multiple buffers and it's not a special buffer
          if
            #vim.fn.getbufinfo({ buflisted = true }) > 1
            and vim.bo.filetype ~= "neo-tree"
            and vim.bo.buftype == ""
          then
            vim.cmd([[
              cnoreabbrev <buffer> q lua require('mini.bufremove').delete(0)
              cnoreabbrev <buffer> q! lua require('mini.bufremove').delete(0, true)
              cnoreabbrev <buffer> wq write <bar> lua require('mini.bufremove').delete(0)
            ]])
          end
        end,
      })
    end,
    keys = {
      -- Buffer closing related shortcuts
      {
        "<leader>q",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "[Q]uit [B]uffer",
      },
      {
        "<leader>Q",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "[Q]uit [B]uffer (Force)",
      },

      -- Save related shortcuts - highly related to buffer management
      { "<leader>w", "<cmd>write<cr>", desc = "[W]rite [F]ile" },
      { "<leader>W", "<cmd>wall<cr>", desc = "[W]rite [A]ll Files" },
      {
        "<leader>wq",
        function()
          vim.cmd.write()
          require("mini.bufremove").delete(0)
        end,
        desc = "[W]rite and [Q]uit Buffer",
      },
      {
        "<leader>wa",
        function()
          -- Save all modified buffers
          vim.cmd("wall")
          vim.notify("All buffers saved", vim.log.levels.INFO)
        end,
        desc = "[W]rite [A]ll Buffers",
      },

      { "<C-s>", "<cmd>write<cr>", desc = "[S]ave [F]ile", mode = { "n", "i", "v" } },
    },
  },
}
