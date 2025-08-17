return {
  {
    "mfussenegger/nvim-lint",
    -- Loads before reading existing files or creating new ones
    -- Ensures linting is ready immediately
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      -- Maps file types to their linters (you need to install these linters separately)
      -- e.g., install markdownlint with: npm install -g markdownlint-cli
      lint.linters_by_ft = {
        markdown = {},
      }

      if vim.fn.executable("markdownlint") == 1 then
        lint.linters_by_ft.markdown = { "markdownlint" }
      end

      -- Augroup prevents duplicate autocmds if config is reloaded
      -- 'clear = true' removes any existing autocmds in this group before creating new ones
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      -- Creates autocommands that trigger linting
      vim.api.nvim_create_autocmd({
        "BufEnter", -- When entering a buffer (switching between files)
        "BufWritePost", -- After saving a file
        "InsertLeave", -- When leaving insert mode (catches changes as you type)
      }, {
        group = lint_augroup,
        callback = function()
          -- vim.bo.modifiable is false for readonly buffers (like help files, quickfix)
          -- Prevents trying to lint files you can't edit
          if vim.bo.modifiable then
            -- Attempts to run appropriate linter based on filetype
            -- 'try_lint' won't error if no linter is configured for current filetype
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
