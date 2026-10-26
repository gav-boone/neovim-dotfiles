return {
  "nvim-treesitter/nvim-treesitter",
  -- Pin to the stable `master` branch. The `main` branch rewrite requires the
  -- external `tree-sitter` CLI to compile parsers; `master` compiles them with
  -- a plain C compiler (gcc/clang on PATH) and ships the classic
  -- `nvim-treesitter.configs` setup API used below.
  branch = "master",
  build = ":TSUpdate",
  config = function()
    -- Use git instead of tarball to avoid ownership errors in containers
    require("nvim-treesitter.install").prefer_git = true

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "typescript", "tsx", "javascript",
        "python", "json", "html", "css", "bash", "markdown",
        "dart", "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
