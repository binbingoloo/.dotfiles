return {
  {
    -- Provides completion and type information for Neovim Lua API
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
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keymaps and settings",
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          -- Helper function to create buffer-local keymaps with consistent options
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to where a symbol is defined (most common operation)
          -- Usage: Place cursor on a function/variable and press 'gd'
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Jump to declaration (different from definition in C/C++)
          -- Usage: In C/C++, jumps to forward declaration in header files
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Find concrete implementations of an interface/abstract method
          -- Usage: On an interface method, find all classes that implement it
          map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Navigate to the type definition of a symbol
          -- Usage: On a variable, jump to its type/class definition
          map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

          -- Find all places where a symbol is used
          -- Usage: See all usages of a function/variable across the project
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- List all symbols in the current file (functions, classes, variables)
          -- Usage: Quick overview and navigation within current file
          map("gs", require("telescope.builtin").lsp_document_symbols, "[G]oto [S]ymbols (Document)")

          -- Search symbols across the entire workspace/project
          -- Usage: Find classes/functions by name across all files
          map("gS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[G]oto [S]ymbols (Workspace)")

          -- Show available code actions (fixes, refactors, imports)
          -- Usage: Fix errors, add imports, extract methods, etc.
          map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          -- Rename symbol across the entire project
          -- Usage: Safely rename variables/functions with all references
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Show hover documentation for symbol under cursor
          -- Usage: Quick info about functions, parameters, types
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          -- Show function signature help
          -- Usage: See parameter hints while typing function calls
          map("gK", vim.lsp.buf.signature_help, "Signature Help")

          -- Show diagnostics in floating window
          map("<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")

          -- C/C++ Specific
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "clangd" then
            map("<leader>oh", "<cmd>ClangdSwitchSourceHeader<cr>", "[O]pen [H]eader/Source")
            map("<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", "[C]lass [T]ype Hierarchy")
            map("<leader>cm", "<cmd>ClangdMemoryUsage<cr>", "[C]langd [M]emory Usage")
            map("<leader>cs", "<cmd>ClangdSymbolInfo<cr>", "[C]langd [S]ymbol Info")
          end

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
        -- Lua
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
        -- C/C++
        clangd = {
          cmd = {
            "clangd",
            "--offset-encoding=utf-16", -- Required for Neovim compatibility
          },
        },

        cssls = {}, -- CSS language server
        tailwindcss = {
          setup = function(_, opts)
            -- get default lspconfig tailwindcss config
            local tw_default = require("lspconfig.server_configurations.tailwindcss").default_config

            opts.filetypes = opts.filetypes or {}
            vim.list_extend(opts.filetypes, tw_default.filetypes or {})

            -- remove excluded filetypes
            opts.filetypes = vim.tbl_filter(function(ft)
              return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
            end, opts.filetypes)

            -- add includeLanguage mappings for Phoenix/Elixir
            opts.settings = {
              tailwindCSS = {
                includeLanguages = {
                  elixir = "html-eex",
                  eelixir = "html-eex",
                  heex = "html-eex",
                },
              },
            }

            -- add additional filetypes
            vim.list_extend(opts.filetypes, opts.filetypes_include or {})
          end,
        },

        stylelint_lsp = {
          filetypes = { "css", "scss", "sass", "less", "postcss" },
          settings = {
            autoFixOnFormat = true,
            -- configOverrides = {
            --   rules = {},
            -- },
          },
        },
      }

      -- Build list of tools to install
      -- Includes LSP servers (from the servers table) and additional tools
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Lua formatter
        "clang-format", -- C/C++ formatter

        -- C/C++ development tools
        "cmake-language-server", -- CMake LSP
        "cmakelint", -- CMake linter
        "cpplint", -- C++ linter
        "cpptools", -- Microsoft C++ tools

        -- Optional: Debugger
        "codelldb", -- High-performance debugger

        -- TypeScript/JavaScript
        "typescript-language-server",
        "prettier",
        "eslint-lsp",

        -- CSS / Tailwind
        "stylelint-lsp", -- LSP wrapper for stylelint
        "stylelint", -- stylelint CLI
        "tailwindcss-language-server", -- Tailwind-specific completions & docs
        "prettierd", -- Fast prettier daemon (better than raw prettier)
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
