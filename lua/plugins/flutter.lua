return {
  "akinsho/flutter-tools.nvim",
  tag = "v2.2.0",
  ft = "dart",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local on_attach = function(_, bufnr)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      -- Standard LSP keymaps (same as your lsp.lua)
      map("gd", vim.lsp.buf.definition, "Go to definition")
      map("gr", vim.lsp.buf.references, "Go to references")
      map("gI", vim.lsp.buf.implementation, "Go to implementation")
      map("K", vim.lsp.buf.hover, "Hover documentation")
      map("<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
      map("gD", vim.lsp.buf.declaration, "Go to declaration")
      map("<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
      map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
      map("]d", vim.diagnostic.goto_next, "Next diagnostic")
      map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")

      -- Flutter-specific keymaps
      map("<leader>fr", "<cmd>FlutterRun<CR>", "Flutter run")
      map("<leader>fq", "<cmd>FlutterQuit<CR>", "Flutter quit")
      map("<leader>fR", "<cmd>FlutterRestart<CR>", "Flutter restart")
      map("<leader>fd", "<cmd>FlutterDevices<CR>", "Flutter devices")
      map("<leader>fo", "<cmd>FlutterOutlineToggle<CR>", "Flutter outline")
      map("<leader>fl", "<cmd>FlutterLspRestart<CR>", "Flutter LSP restart")
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("flutter-tools").setup({
      ui = {
        border = "rounded",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        enabled = true,
      },
      lsp = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = {
            vim.fn.expand("$HOME/.pub-cache"),
          },
          enableSnippets = true,
        },
      },
    })
  end,
}
