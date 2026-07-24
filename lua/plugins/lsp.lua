return {
  -- LSP config
  {
    "neovim/nvim-lspconfig",
    tag = "v2.4.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      { "williamboman/mason-lspconfig.nvim", tag = "v1.32.0" },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Setup mason first (manages LSP server installs)
      require("mason").setup()

      -- Bridge between mason and lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",        -- TypeScript/JavaScript
          "lua_ls",       -- Lua
          "basedpyright", -- Python type checking, completions, hover
          "ruff",         -- Python linting + formatting
        },
      })

      -- Shared capabilities (enables completion via nvim-cmp)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Shared on_attach for keymaps
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

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
      end

      -- Setup each server
      local lspconfig = require("lspconfig")

      require("mason-lspconfig").setup_handlers({
        -- Default handler for all servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,
        -- Custom handler for lua_ls (suppress vim global warnings)
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
              },
            },
          })
        end,
        -- basedpyright: type checking + completions, disable its formatting
        ["basedpyright"] = function()
          lspconfig.basedpyright.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              basedpyright = {
                analysis = {
                  typeCheckingMode = "standard",
                },
              },
            },
          })
        end,
        -- ruff: linting + formatting
        ["ruff"] = function()
          lspconfig.ruff.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              -- Disable ruff's hover (let basedpyright handle it)
              client.server_capabilities.hoverProvider = false
              on_attach(client, bufnr)
            end,
          })
        end,
      })

      -- Format on save (uses ruff for Python, ts_ls for TS, etc.)
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
