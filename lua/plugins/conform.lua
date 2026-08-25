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
    opts = {},
  },
}
