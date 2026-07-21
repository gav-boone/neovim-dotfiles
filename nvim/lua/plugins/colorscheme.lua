-- Colorscheme: tokyonight
-- A clean, dark theme that's easy on the eyes
return {
  "folke/tokyonight.nvim",
  lazy = false,    -- load immediately
  priority = 1000, -- load before other plugins
  config = function()
    require("tokyonight").setup({
      style = "night", -- darkest variant
      transparent = false,
    })
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
