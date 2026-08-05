-- Render markdown nicely inside Neovim buffers
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "markdown" },
    opts = {
      heading = {
        enabled = true,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "☐ " },
        checked = { icon = "☑ " },
      },
      code = {
        enabled = true,
        style = "full",
        border = "thin",
      },
      dash = {
        enabled = true,
        icon = "─",
      },
      link = {
        enabled = true,
        hyperlink = "🔗",
      },
      pipe_table = {
        enabled = true,
        style = "full",
      },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown render" },
    },
  },
}
