return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,           -- use treesitter to check for pairs (you have treesitter)
    ts_config = {
      lua = { "string" },      -- don't add pairs in lua string treesitter nodes
      javascript = { "template_string" },
    },
    fast_wrap = {
      map = "<M-e>",           -- Alt+e to wrap with a pair
    },
  },
}
