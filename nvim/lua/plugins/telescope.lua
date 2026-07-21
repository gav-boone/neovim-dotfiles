-- Telescope: fuzzy finder for files, text, and more
-- Key tool — you'll use this constantly
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "dist/", "__pycache__" },
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.55 },
      },
    })
    telescope.load_extension("fzf")

    -- Keymaps — all start with <leader>f (find)
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find text (grep)" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
  end,
}
