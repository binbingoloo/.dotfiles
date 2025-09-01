return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Runs TreeSitter's update command after install to compile parsers
    build = ":TSUpdate",
    -- Specifies the module to configure (required when using opts instead of config function)
    main = "nvim-treesitter.configs",
    opts = {
      -- Core languages that should always be installed
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "make",
        "javascript",
        "typescript",
        "tsx",
        "css",
        "json",
        "jsonc",
        "yaml",
      },
      -- Automatically installs parsers for new file types you open
      auto_install = true,
      highlight = {
        enable = true,
        -- Ruby's syntax is too complex for TreeSitter alone, needs vim's regex for accurate highlighting
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = {
        enable = true,
        -- Ruby indentation conflicts with regex highlighting, causing incorrect indent levels
        disable = { "ruby" },
      },
    },
  },
}
