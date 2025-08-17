return {
  {
    -- Provides completion and type information for Neovim Lua API
    -- This plugin enhances the development experience when writing Neovim configuration
    -- by providing accurate completions, type checking, and documentation
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Dynamically loads luvit type definitions when vim.uv is referenced
        -- vim.uv provides access to libuv functionality for async operations
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Mason manages external editor tooling (LSP servers, linters, formatters)
      -- It installs them in a central location and handles updates
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- Provides UI feedback for LSP operations (loading, progress, etc.)
      { "j-hui/fidget.nvim", opts = {} },
      -- Enhanced completion capabilities that integrate with LSP
      "saghen/blink.cmp",
    },
    config = function()
      -- LSP (Language Server Protocol) enables IDE-like features in Neovim
      -- This autocmd runs when an LSP client attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keymaps and settings",
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          -- Helper function to create buffer-local keymaps with consistent options
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Rename symbols across the entire project (variables, functions, classes)
          -- Most LSPs handle renaming in all files where the symbol is used
          map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Code actions are context-aware fixes or refactoring options
          -- Examples: fix imports, extract method, implement interface
          map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

          -- Find all locations where the symbol under cursor is referenced
          map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Implementation differs from definition - shows concrete implementations
          -- Example: for an interface method, shows all classes implementing it
          map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to where a symbol is defined (not just declared)
          -- Press <C-t> to jump back to previous location
          map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Declaration is distinct from definition in languages like C/C++
          -- Declaration: function signature in header file
          -- Definition: actual function body in source file
          map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- List all symbols (functions, variables, classes) in current file
          map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

          -- Search symbols across entire workspace/project
          map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

          -- Type definition navigates to the type's declaration, not the variable's
          -- Example: for 'const user: User', jumps to the User type definition
          map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

          -- Compatibility wrapper for different Neovim versions
          -- Neovim 0.11 changed the method signature for supports_method
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Document highlight automatically highlights other occurrences of the symbol under cursor
          -- This helps visualize where a variable/function is used in the current buffer
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

            -- Trigger highlight when cursor stops moving (in normal or insert mode)
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              desc = "Highlight symbol under cursor",
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            -- Clear highlights when cursor moves
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              desc = "Clear symbol highlights",
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            -- Clean up highlights when LSP detaches from buffer
            vim.api.nvim_create_autocmd("LspDetach", {
              desc = "Clean up LSP highlights on detach",
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- Inlay hints display additional information inline in your code
          -- Examples: parameter names in function calls, inferred types, return types
          -- Can be visually noisy, so they're toggleable
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Configure how diagnostics (errors, warnings) are displayed
      vim.diagnostic.config({
        -- Sort diagnostics by severity (errors first, then warnings, etc.)
        severity_sort = true,
        -- Floating window style when hovering over diagnostics
        float = {
          border = "rounded", -- Rounded border for floating windows
          source = "if_many", -- Show source of diagnostic if multiple sources exist
        },
        -- Only underline errors, not warnings/info/hints to reduce visual noise
        underline = { severity = vim.diagnostic.severity.ERROR },
        -- Diagnostic signs in the sign column (left side of editor)
        -- Uses Nerd Font icons if available, otherwise uses default text
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        -- Virtual text shows diagnostics inline at the end of lines
        virtual_text = {
          source = "if_many", -- Show diagnostic source if multiple sources
          spacing = 2, -- Spacing before virtual text
          -- Custom formatter ensures consistent message display across severity levels
          -- This example just returns the message as-is, but could be customized
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      -- Get enhanced capabilities from blink.cmp
      -- This includes snippets support, additional completion features, etc.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Server-specific configurations
      -- Each LSP server can have unique settings
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                -- Replace function call snippets instead of inserting
                callSnippet = "Replace",
              },
            },
          },
        },
      }

      -- Build list of tools to install
      -- Includes LSP servers (from the servers table) and additional tools
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Lua formatter
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      -- Configure mason-lspconfig to set up LSP servers
      require("mason-lspconfig").setup({
        ensure_installed = {}, -- Empty means don't force any installations
        automatic_installation = false, -- Don't auto-install servers when opening files
        handlers = {
          -- Default handler runs for each installed server
          -- Merges server-specific settings with enhanced capabilities
          function(server_name)
            local server = servers[server_name] or {}
            -- Deep merge: base capabilities + server-specific capabilities
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
