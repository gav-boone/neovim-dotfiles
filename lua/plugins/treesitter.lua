return {
  "nvim-treesitter/nvim-treesitter",
  -- Use the `main` branch: the legacy `master` branch is capped at older
  -- Neovim versions and crashes on 0.12 (its query_predicates return a node
  -- list that 0.12's get_node_text/get_range no longer accept — the
  -- "attempt to call method 'range' (a nil value)" error). `main` is the
  -- 0.11+/0.12 line. It compiles parsers with the external `tree-sitter` CLI
  -- (installed at Programs\tree-sitter and on PATH via init.lua).
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local ok, ts = pcall(require, "nvim-treesitter")
    if ok and ts.setup then
      ts.setup()
    end

    local ensure = {
      "lua", "typescript", "tsx", "javascript",
      "python", "json", "html", "css", "bash", "markdown",
      "markdown_inline", "yaml", "c", "cpp",
    }

    -- Install any missing parsers (async). Guarded so it never errors startup.
    pcall(function()
      require("nvim-treesitter").install(ensure)
    end)

    -- Enable treesitter highlighting + indentation when a buffer opens, but
    -- only if a parser for that language is actually available.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if pcall(vim.treesitter.start, args.buf, lang) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
