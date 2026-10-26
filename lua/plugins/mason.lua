-- Dedicated spec for mason.nvim.
--
-- Previously mason was only a *dependency* of nvim-lspconfig, and
-- require("mason").setup() ran inside that plugin's event-gated config
-- (BufReadPre/BufNewFile). As a result the :Mason / :MasonInstall user commands
-- did not exist until an LSP buffer event fired — so :Mason failed with
-- "E492: Not an editor command: Mason" on startup. Giving mason its own spec
-- that calls setup() eagerly (and registers on the Mason* commands) makes the
-- commands always available and ensures mason's bin dir is on PATH so installed
-- tools are runnable.
return {
  "williamboman/mason.nvim",
  lazy = false,
  priority = 100, -- load before lspconfig/conform so their setup() finds it ready
  build = ":MasonUpdate",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
    "MasonUpdate",
  },
  config = function()
    require("mason").setup()

    -- Make sure Mason's shim/bin directory is on PATH so installed servers,
    -- linters and formatters can actually be launched.
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    if vim.fn.isdirectory(mason_bin) == 1 and not (vim.env.PATH or ""):find(mason_bin, 1, true) then
      vim.env.PATH = mason_bin .. (vim.fn.has("win32") == 1 and ";" or ":") .. vim.env.PATH
    end
  end,
}
