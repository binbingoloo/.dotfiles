return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",

    -- Required dependency for nvim-dap-ui
    "nvim-neotest/nvim-nio",

    -- Installs and manages debug adapters (like language servers but for debugging)
    "mason-org/mason.nvim",
    -- Bridge between Mason and nvim-dap, handles automatic debugger setup
    "jay-babu/mason-nvim-dap.nvim",

    -- Go-specific debugging configuration (sets up delve debugger)
    "leoluz/nvim-dap-go",

    -- Inline Variable support
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F1>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F2>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F3>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle UI",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Set Conditional Breakpoint",
    },
    {
      "<leader>dl",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end,
      desc = "Debug: Set Logpoint",
    },
    {
      "<leader>dv",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "Debug: View Variable",
      mode = { "n", "v" },
    },
    -- Add the word under cursor to watches
    {
      "<leader>dw",
      function()
        local word = vim.fn.expand("<cword>") -- Get word under cursor
        require("dapui").elements.watches.add(word)
      end,
      desc = "Debug: Add Word to Watches",
      mode = "n",
    },
    -- Add custom expression to watches
    {
      "<leader>dW",
      function()
        local expr = vim.fn.input("Expression to watch: ")
        if expr ~= "" then
          require("dapui").elements.watches.add(expr)
        end
      end,
      desc = "Debug: Add Expression to Watches",
      mode = "n",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      -- Automatically installs debug adapters when you open relevant file types
      automatic_installation = true,
      -- Empty handlers table means use default setup for all adapters
      -- You can override specific adapters here if needed
      handlers = {},
      -- Pre-installs these debug adapters even before opening relevant files
      ensure_installed = {
        "delve", -- Go debugger
        "codelldb", -- LLDB adapter
      },
    })

    dapui.setup({
      -- Tree-style icons for expanding/collapsing variable inspectors
      icons = {
        expanded = "▾", -- Shown when a section is expanded
        collapsed = "▸", -- Shown when a section is collapsed
        current_frame = "*", -- Marks the current stack frame in call stack window
      },
      -- Icons for debugger control buttons in the UI
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎", -- Goes into function calls
          step_over = "⏭", -- Executes current line without entering functions
          step_out = "⏮", -- Finishes current function and returns to caller
          step_back = "b", -- Some debuggers support stepping backwards
          run_last = "▶▶", -- Reruns the last debug session
          terminate = "⏹", -- Forcefully stops the debug session
          disconnect = "⏏", -- Disconnects debugger but leaves program running
        },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "dap-float", "dapui*" },
      callback = function()
        vim.keymap.set("n", "<Esc>", function()
          vim.cmd.close()
        end, { buffer = true, noremap = true, silent = true })
      end,
    })

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.expand("~/.local/share/nvim/mason/bin/codelldb"),
        args = { "--port", "${port}" },
      },
    }

    -- C/C++ Debbuger Configurations
    dap.configurations.c = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          -- Auto dectect executable file path
          if vim.fn.isdirectory(vim.fn.getcwd() .. "/build") == 1 then
            return vim.fn.getcwd() .. "/build/main"
          else
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end
        end,
        cwd = "${workspaceFolder}",
      },
    }

    dap.configurations.cpp = dap.configurations.c

    vim.api.nvim_create_user_command("DebugC", function()
      if vim.fn.filereadable(vim.fn.getcwd() .. "/build/main") == 1 then
        dap.run(dap.configurations.c[1])
      else
        vim.cmd("!make")
        if vim.v.shell_error == 0 then
          dap.run(dap.configurations.c[1])
        end
      end
    end, { nargs = 0 })

    -- Automatically open dapui when debugging starts
    -- event_initialized fires when debugger successfully connects to your program
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open

    -- Automatically close dapui when debugging ends
    -- event_terminated fires when program is terminated by debugger
    -- dap.listeners.before.event_terminated["dapui_config"] = dapui.close

    -- event_exited fires when program exits normally
    -- dap.listeners.before.event_exited["dapui_config"] = dapui.close

    require("dap-go").setup({
      delve = {
        -- On Windows, delve must run in attached mode (false)
        -- On Unix systems, it can run detached (true) which is more stable
        -- vim.fn.has("win32") returns 1 on Windows, 0 on Unix
        detached = vim.fn.has("win32") == 0,
      },
    })
  end,
}
