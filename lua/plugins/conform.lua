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
          require("conform").format({ async = false, lsp_format = "prefer" })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      -- Only real CLI formatters belong in this map. LSP-driven formatting is
      -- NOT a formatter here — "lsp" is not a valid formatter name (conform
      -- FAQ: you cannot define an "lsp" formatter). It's controlled by the
      -- lsp_format option below. Filetypes with no entry here (python, ts,
      -- js, lua) fall through to LSP formatting via default_format_opts.
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      -- Prefer the attached LSP for formatting whenever one is available.
      -- Applies to every conform.format() call (including format_on_save).
      default_format_opts = {
        lsp_format = "prefer",
      },
      format_on_save = {
        timeout_ms = 2000,
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
