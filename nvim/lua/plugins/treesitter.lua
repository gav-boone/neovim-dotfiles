-- Treesitter: syntax highlighting and code understanding
-- Makes code actually readable with proper colors per language
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Languages to install parsers for
      ensure_installed = {
        "lua", "javascript", "typescript", "tsx",
        "python", "json", "yaml", "html", "css",
        "bash", "markdown", "markdown_inline",
      },
      auto_install = true,  -- auto-install parsers for new file types
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
