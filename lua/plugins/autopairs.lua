return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    -- treesitter has been removed; disable ts-based pair checking so autopairs
    -- falls back to its built-in heuristics.
    check_ts = false,
    fast_wrap = {
      map = "<M-e>",           -- Alt+e to wrap with a pair
    },
  },
}
