local M = {}

-- Default workspaces configuration
M.config = {
  default = "workspace",
  spaces = {
    {
      name = "workspace",
      path = os.getenv("HOME"),
    },
    -- Add your projects here:
    -- {
    --   name = "dotfiles",
    --   path = os.getenv("HOME") .. "/.dotfiles"
    -- },
    -- {
    --   name = "work",
    --   path = os.getenv("HOME") .. "/Work",
    --   tabs = { "frontend", "backend", "docs" }
    -- },
  }
}

return M
