return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    tag = "v8.1.0",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = false, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "ruff_format" },
        typescript = { "lsp" },
        javascript = { "lsp" },
        lua = { "lsp" },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
    },
  },

  -- Auto-install formatters via Mason
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "stevearc/conform.nvim",
      "williamboman/mason.nvim",
    },
    opts = {
      -- Don't let mason-conform try to install these:
      --  * "lsp"         — not a real formatter, resolves to the attached LSP client
      --  * "ruff_format" — ruff is provided via conda (bootstrap.sh), not Mason
      --  * "clang-format"— installed/managed separately
      -- Attempting to install non-Mason/pseudo formatters triggers a nil-index
      -- error in mason-conform's install path.
      ignore_install = { "lsp", "ruff_format", "clang-format" },
    },
  },
}
