return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local palettes = {
      carbonfox = {
        -- Match wezterm custom colors
        bg0 = "#0A1520",
        bg1 = "#0D1E2C",
        bg2 = "#132738",
        bg3 = "#1A3248",
        bg4 = "#264F78",

        fg0 = "#FFFFFF",
        fg1 = "#BFC6CA",
        fg2 = "#a6adc8",
        fg3 = "#585b70",

        sel0 = "#264F78",
        sel1 = "#1A3248",

        black = { base = "#45475a", bright = "#585b70", dim = "#313244" },
        red = { base = "#f38ba8", bright = "#f38ba8", dim = "#c74870" },
        green = { base = "#a6e3a1", bright = "#a6e3a1", dim = "#6fbf6a" },
        yellow = { base = "#f9e2af", bright = "#f9e2af", dim = "#c9b27f" },
        blue = { base = "#89b4fa", bright = "#89b4fa", dim = "#5984ca" },
        magenta = { base = "#f5c2e7", bright = "#f5c2e7", dim = "#c592b7" },
        cyan = { base = "#94e2d5", bright = "#94e2d5", dim = "#64b2a5" },
        white = { base = "#bac2de", bright = "#a6adc8", dim = "#8a92ae" },
        orange = { base = "#fab387", bright = "#fab387", dim = "#ca8357" },
        pink = { base = "#f5c2e7", bright = "#f5c2e7", dim = "#c592b7" },

        comment = "#585b70",
      },
    }

    require("nightfox").setup({
      options = {
        transparent = true,
      },
      palettes = palettes,
    })
    vim.cmd.colorscheme("carbonfox")
  end,
}
