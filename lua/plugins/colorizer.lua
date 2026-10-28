return {
  -- Maintained fork of norcalli/nvim-colorizer.lua. The original is
  -- unmaintained and calls the deprecated vim.tbl_flatten (nvim 0.13+
  -- deprecation warning on every startup); the catgoose fork fixes that and
  -- is a drop-in replacement with a single-table setup() API.
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    filetypes = { "*" }, -- enable for all filetypes
    user_default_options = {
      RGB = true,          -- #RGB hex codes
      RRGGBB = true,       -- #RRGGBB hex codes
      names = false,       -- named colors (e.g. "Blue")
      RRGGBBAA = true,     -- #RRGGBBAA hex codes
      css = true,          -- CSS features: rgb_fn, hsl_fn
      css_fn = true,       -- CSS functions: rgb(), hsl()
      mode = "background",  -- "foreground", "background", or "virtualtext"
    },
  },
}
