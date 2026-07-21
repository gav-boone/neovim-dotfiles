-- Completion: autocomplete as you type
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- only load when you start typing
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",   -- LSP completions
    "hrsh7th/cmp-buffer",     -- words from current file
    "hrsh7th/cmp-path",       -- file paths
    "L3MON4D3/LuaSnip",      -- snippet engine (required)
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
        ["<C-n>"] = cmp.mapping.select_next_item(),     -- next suggestion
        ["<C-p>"] = cmp.mapping.select_prev_item(),     -- previous suggestion
        ["<C-Space>"] = cmp.mapping.complete(),          -- trigger completion
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept selection
        ["<C-e>"] = cmp.mapping.abort(),                 -- close menu
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },  -- LSP suggestions (highest priority)
        { name = "luasnip" },
        { name = "buffer" },    -- words from file
        { name = "path" },      -- file paths
      }),
    })
  end,
}
