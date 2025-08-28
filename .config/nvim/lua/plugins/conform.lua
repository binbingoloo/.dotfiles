return {
  {
    "stevearc/conform.nvim",
    -- Loads when about to save a file (needed for format-on-save functionality)
    event = { "BufWritePre" },
    -- Also loads when running :ConformInfo to check formatter status
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          -- async prevents blocking while formatting large files
          -- lsp_format = 'fallback' uses LSP formatting if no dedicated formatter is configured
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        -- Empty mode string means this works in normal, visual, and visual-line modes
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      -- Silently fails instead of showing error notifications when formatters crash
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            -- Prevents hanging on slow formatters
            timeout_ms = 500,
            -- Falls back to LSP's built-in formatter if no external formatter is found
            lsp_format = "fallback",
          }
        end
      end,
      formatters_by_ft = {
        -- External formatters provide better formatting than LSP built-ins
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },
}
