-- LSP: Language Server Protocol support
-- Gives you autocomplete, go-to-definition, error highlighting, etc.
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",           -- installs LSP servers for you
      "williamboman/mason-lspconfig.nvim",  -- bridges mason + lspconfig
    },
    config = function()
      -- Mason manages LSP server installations
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",        -- TypeScript/JavaScript
          "pyright",         -- Python
          "lua_ls",          -- Lua (for editing nvim config)
        },
        automatic_installation = true,
        automatic_enable = false,  -- requires Neovim 0.11+; disable for 0.10
      })

      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Add completion capabilities (from nvim-cmp)
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Keymaps that activate when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>d", vim.diagnostic.open_float, "Show diagnostic")
          map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
        end,
      })

      -- Configure each server
      local servers = { "ts_ls", "pyright", "lua_ls" }
      for _, server in ipairs(servers) do
        local opts = { capabilities = capabilities }

        -- Lua LSP: tell it about vim globals
        if server == "lua_ls" then
          opts.settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              diagnostics = { globals = { "vim" } },
            },
          }
        end

        lspconfig[server].setup(opts)
      end
    end,
  },
}
