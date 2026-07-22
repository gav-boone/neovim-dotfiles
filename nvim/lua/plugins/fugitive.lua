return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G" },
  keys = {
    { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
    { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff split" },
    { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
    { "<leader>gl", "<cmd>Git log --oneline<CR>", desc = "Git log" },
  },
}
