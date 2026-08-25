return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      "*", -- enable for all filetypes
    }, {
      RGB = true,      -- #RGB hex codes
      RRGGBB = true,   -- #RRGGBB hex codes
      names = false,   -- named colors (e.g. "Blue")
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      css = true,      -- CSS features: rgb_fn, hsl_fn
      css_fn = true,   -- CSS functions: rgb(), hsl()
      mode = "background", -- "foreground", "background", or "virtualtext"
    })
  end,
}
