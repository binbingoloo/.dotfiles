return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          cmdline = { title = "" },
          search_down = { title = "" },
          search_up = { title = "" },
          filter = { title = "" },
          lua = { title = "" },
          help = { title = "" },
          input = { title = "" },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d fewer lines" },
              { find = "%d more lines" },
            },
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B written" },
            },
          },
          view = "mini",
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
        },
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "[R]edirect [C]mdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "[S]how [L]ast Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "[S]how [H]istory",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "[S]how [A]ll Messages",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "[D]ismiss [A]ll",
      },
      {
        "<leader>snt",
        function()
          require("noice").cmd("telescope")
        end,
        desc = "[S]earch with [T]elescope",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "[S]croll [F]orward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "[S]croll [B]ackward",
        mode = { "i", "n", "s" },
      },
    },
  },
}
