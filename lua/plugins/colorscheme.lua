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

      -- Forest-green theme for the "home" profile. Deep evergreen backgrounds
      -- with warm, leafy accents. Built on nightfox's "nightfox" base scheme
      -- (see config/themes.lua -> profiles.home.colorscheme = "nightfox").
      nightfox = {
        bg0 = "#0b1a12", -- dimmest (status line edges)
        bg1 = "#0f2417", -- normal background (deep forest)
        bg2 = "#143020", -- lighter bg (visual, cursorline)
        bg3 = "#1d4a30", -- selection / popup
        bg4 = "#2f6b47", -- line numbers, comments bg

        fg0 = "#f0f5ee", -- brightest text
        fg1 = "#d6e6cf", -- normal text (soft sage white)
        fg2 = "#a9c7a0", -- dimmer text
        fg3 = "#6f8f67", -- faded (comments)

        sel0 = "#1d4a30", -- popup bg
        sel1 = "#2f6b47", -- popup selection

        black = { base = "#0f2417", bright = "#1d4a30", dim = "#0b1a12" },
        red = { base = "#e06c75", bright = "#ef7a83", dim = "#b85a62" },
        green = { base = "#8fd86b", bright = "#a6e38a", dim = "#6fae54" },
        yellow = { base = "#d7c56a", bright = "#e6d57e", dim = "#ab9d55" },
        blue = { base = "#6fb3a8", bright = "#86c9bd", dim = "#5a8f87" },
        magenta = { base = "#c48fd0", bright = "#d3a3dd", dim = "#9d72a6" },
        cyan = { base = "#79c9b6", bright = "#8fddc9", dim = "#61a191" },
        white = { base = "#d6e6cf", bright = "#f0f5ee", dim = "#a9c7a0" },
        orange = { base = "#e0a15c", bright = "#efb374", dim = "#b3814a" },
        pink = { base = "#e0a7c8", bright = "#efbdd7", dim = "#b385a0" },

        comment = "#6f8f67",
      },

      -- High-contrast light theme for the "present" profile: built for
      -- screenshots and screen shares. Pure-white background with black text
      -- for maximum contrast, plus saturated, well-spaced accent hues that
      -- survive video compression and projector washout. Built on nightfox's
      -- light "dayfox" base scheme
      -- (config/themes.lua -> profiles.present.colorscheme = "dayfox").
      dayfox = {
        bg0 = "#eaeaea", -- dimmest (status edges)
        bg1 = "#ffffff", -- normal background (pure white)
        bg2 = "#e8e8e8", -- visual / cursorline (clearly visible band)
        bg3 = "#d4d4d4", -- selection / popup
        bg4 = "#b0b0b0", -- line numbers

        fg0 = "#000000", -- max-contrast text
        fg1 = "#0a0a0a", -- normal text (black)
        fg2 = "#262626", -- dimmer text
        fg3 = "#565656", -- faded (comments still readable)

        sel0 = "#d4d4d4", -- popup bg
        sel1 = "#b0b0b0", -- popup selection

        -- Dark, saturated accents so syntax reads on a white bg even after
        -- compression. Dimmed variants kept dark on purpose.
        black = { base = "#0a0a0a", bright = "#000000", dim = "#262626" },
        red = { base = "#b3001b", bright = "#8a0015", dim = "#8a2020" },
        green = { base = "#0e6b2e", bright = "#0a5424", dim = "#265a35" },
        yellow = { base = "#845400", bright = "#684200", dim = "#75601f" },
        blue = { base = "#0747a6", bright = "#06367e", dim = "#244e8a" },
        magenta = { base = "#6f36c9", bright = "#582aa1", dim = "#5a3f8a" },
        cyan = { base = "#0a6075", bright = "#074a5b", dim = "#215866" },
        white = { base = "#262626", bright = "#0a0a0a", dim = "#565656" },
        orange = { base = "#a83c00", bright = "#852f00", dim = "#8f4720" },
        pink = { base = "#8f0f73", bright = "#73005c", dim = "#7a2f68" },

        comment = "#565656",
      },
    }

    -- Theme profiles live in lua/config/themes.lua so they're configurable
    -- without touching this file.
    local themes = require("config.themes")

    -- Apply a profile by name. nightfox bakes `transparent` into setup(), so
    -- switching transparency means re-running setup() before :colorscheme.
    -- The stock "default" scheme isn't a nightfox scheme, so for it we just
    -- load the colorscheme directly (opaque).
    local function apply(name)
      local profile = themes.profiles[name]
      if not profile then
        vim.notify("Unknown theme profile: " .. tostring(name), vim.log.levels.ERROR)
        return
      end

      -- Re-configure nightfox for the requested transparency. Harmless even
      -- when loading the non-nightfox "default" scheme.
      require("nightfox").setup({
        options = {
          transparent = profile.transparent == true,
        },
        palettes = palettes,
      })

      vim.cmd.colorscheme(profile.colorscheme)
      vim.g.theme_profile = name
    end

    -- Apply the startup profile for this machine.
    apply(themes.startup)

    -- :Theme <name> — switch profiles live, with tab-completion of the
    -- profile names defined in config/themes.lua.
    vim.api.nvim_create_user_command("Theme", function(args)
      if args.args == nil or args.args == "" then
        vim.notify("Current theme profile: " .. tostring(vim.g.theme_profile), vim.log.levels.INFO)
        return
      end
      apply(args.args)
    end, {
      nargs = "?",
      desc = "Switch color theme profile (see lua/config/themes.lua)",
      complete = function(arglead)
        local names = {}
        for name in pairs(themes.profiles) do
          if name:find(arglead, 1, true) == 1 then
            table.insert(names, name)
          end
        end
        table.sort(names)
        return names
      end,
    })
  end,
}
