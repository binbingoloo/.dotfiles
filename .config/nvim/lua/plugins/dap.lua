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
      "<leader>b",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>B",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Set Breakpoint",
    },
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: See last session result.",
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

    -- Automatically open dapui when debugging starts
    -- event_initialized fires when debugger successfully connects to your program
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open

    -- Automatically close dapui when debugging ends
    -- event_terminated fires when program is terminated by debugger
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close

    -- event_exited fires when program exits normally
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

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
