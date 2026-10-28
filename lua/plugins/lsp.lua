return {
  -- LSP config
  {
    "neovim/nvim-lspconfig",
    tag = "v2.12.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      { "williamboman/mason-lspconfig.nvim", tag = "v2.3.0" },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- mason itself is set up eagerly in lua/plugins/mason.lua (so :Mason
      -- and friends always exist). Here we only wire up the LSP servers.

      -- Shared capabilities (enables completion via nvim-cmp)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Deterministic LSP formatting. When more than one attached client can
      -- format a buffer, `vim.lsp.buf.format` would otherwise prompt or run
      -- them all. We pick exactly one via an explicit preference per filetype,
      -- so adding another formatting-capable server never causes a double
      -- format or a chooser popup. Unknown filetypes just use whatever single
      -- client advertises formatting.
      local format_prefer = {
        python = "ruff", -- ruff formats; basedpyright doesn't, but be explicit
      }
      _G._lsp_format = function(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype
        local preferred = format_prefer[ft]
        vim.lsp.buf.format({
          bufnr = bufnr,
          timeout_ms = 2000,
          filter = function(c)
            if preferred then
              return c.name == preferred
            end
            return true
          end,
        })
      end

      -- Shared on_attach for keymaps. Attached via LspAttach autocmd below so
      -- it applies to every server regardless of how it's enabled.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local bufnr = ev.buf
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
          map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")

          -- Manual format via the attached LSP. `vim.lsp.buf.format` only asks
          -- clients that advertise formatting capability, so this is a no-op
          -- for servers that don't format. When several clients can format the
          -- same buffer, `_lsp_format` picks one deterministically so you never
          -- get a double-format or a chooser prompt.
          map("<leader>f", function() _G._lsp_format(ev.buf) end, "Format buffer (LSP)")

          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- ruff: let basedpyright own hover, disable ruff's.
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          -- Format on save, driven entirely by the LSP. Any server installed
          -- via Mason that supports textDocument/formatting participates
          -- automatically — no per-server config needed. Servers that don't
          -- advertise the capability are skipped.
          if client and client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspFormatOnSave." .. bufnr, { clear = true }),
              buffer = bufnr,
              callback = function()
                _G._lsp_format(bufnr)
              end,
            })
          end
        end,
      })

      -- Per-server settings. On nvim 0.11+ servers are configured with
      -- vim.lsp.config(name, opts); these merge on top of the default configs
      -- shipped by nvim-lspconfig. mason-lspconfig v2 (no more setup_handlers)
      -- auto-enables installed servers for us.
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- basedpyright: bound analysis scope to avoid OOM from indexing the whole
      -- workspace (.venv/site-packages, large stub trees).
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              exclude = {
                "**/node_modules",
                "**/__pycache__",
                "**/.venv",
                "**/.git",
                "**/dist",
                "**/build",
              },
            },
          },
        },
      })

      -- clangd: point it at the portable MinGW toolchain. clangd does not
      -- auto-discover WinLibs mingw's header/lib paths (standard headers live
      -- under mingw64\x86_64-w64-mingw32\include, and C++ headers under
      -- mingw64\include\c++\<ver>), so without --query-driver it fails to find
      -- <stdio.h>/<string.h> etc. --query-driver lets clangd interrogate gcc
      -- for its system include + library search paths.
      do
        local mingw = "C:/Users/gboone/Programs/mingw64"
        local gcc = mingw .. "/bin/gcc.exe"
        if vim.fn.filereadable(gcc) == 1 then
          vim.lsp.config("clangd", {
            cmd = {
              "clangd",
              "--query-driver=" .. mingw .. "/bin/*",
              "--background-index",
              "--clang-tidy",
            },
          })
        end
      end

      -- Bridge mason -> lsp. v2 auto-enables servers it installs; pyright is
      -- intentionally omitted so it never attaches alongside basedpyright.
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",        -- TypeScript/JavaScript
          "lua_ls",       -- Lua
          "basedpyright", -- Python type checking, completions, hover
          "ruff",         -- Python linting + formatting
          "clangd",       -- C/C++
        },
        automatic_enable = {
          exclude = { "pyright" },
        },
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
