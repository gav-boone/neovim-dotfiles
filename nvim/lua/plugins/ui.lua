-- Quality of life plugins
return {
  -- Auto-close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true, -- uses default config
  },

  -- Comment lines with gcc (normal) or gc (visual)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },

  -- Show indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = true },
      })
    end,
  },

  -- Git signs in the gutter (added/modified/deleted lines)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
        },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = "|",
          section_separators = "",
        },
      })
    end,
  },

  -- File explorer (toggle with <leader>e)
  {
    "nvim-tree/nvim-tree.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Disable netrw (vim's built-in file explorer)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        view = { width = 30 },
        filters = { dotfiles = false },
      })

      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    end,
  },

  -- Which-key: shows available keybinds as you type
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        delay = 500, -- show after 500ms
      })
    end,
  },
}
