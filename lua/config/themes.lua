-- Theme profiles for :Theme and startup.
--
-- Edit this file to change which colorscheme each profile uses, or which
-- profile loads on startup. colorscheme.lua reads this table, applies the
-- startup profile, and registers the :Theme <name> command (with completion)
-- to switch between profiles live.
--
-- Each profile:
--   colorscheme  (string)  name passed to :colorscheme
--   transparent  (bool)    whether the background is transparent
--                          (only meaningful for the nightfox-based profiles)
--
-- To add a profile, add another entry under `profiles` and it becomes
-- available to :Theme automatically.

return {
  -- Which profile loads on startup (per machine). "work" = carbonfox.
  startup = "work",

  profiles = {
    -- Stock Neovim look: the classic built-in "default" scheme, opaque bg.
    default = {
      colorscheme = "default",
      transparent = false,
    },

    -- This machine's working theme: custom carbonfox (see colorscheme.lua),
    -- transparent so the terminal background shows through.
    work = {
      colorscheme = "carbonfox",
      transparent = true,
    },

    -- Forest-green theme: custom "forestfox" palette applied over nightfox's
    -- base scheme (see the `nightfox` palette in colorscheme.lua).
    home = {
      colorscheme = "nightfox",
      transparent = true,
    },

    -- High-contrast light theme for screenshots / screen shares. Opaque on
    -- purpose: transparency ruins legibility over video and in captures.
    -- Custom light palette over nightfox's "dayfox" base (see colorscheme.lua).
    present = {
      colorscheme = "dayfox",
      transparent = false,
    },
  },
}
