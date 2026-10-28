# neovim-dotfiles

Personal Neovim config

## Plugins

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) | Colorscheme — drives the `work`/`home` theme profiles (custom palettes) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF sorter for telescope |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/tool installer |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Bridge between mason and lspconfig |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer completion source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion source |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | LuaSnip completion source |
| [harpoon2](https://github.com/ThePrimeagen/harpoon) | Quick file navigation |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git commands in vim |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter, hunk actions |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets/quotes |
| [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) | Inline color highlighting |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim) | Better UI for vim.ui.input/select |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library (dependency) |

> Note: nvim-treesitter is not installed. flutter-tools.nvim and
> render-markdown.nvim are also not part of this config.

## Key Bindings

Leader key is `Space`.

### General

| Key | Mode | Action |
|-----|------|--------|
| `<leader>w` | n | Save file |
| `<leader>q` | n | Quit window |
| `<Esc>` | n | Clear search highlights |
| `<C-h/j/k/l>` | n | Navigate between windows |
| `<C-d>` | n | Scroll down (centered) |
| `<C-u>` | n | Scroll up (centered) |
| `J` | v | Move selection down |
| `K` | v | Move selection up |
| `<leader>p` | v | Paste without overwriting register |
| `<leader>b` | n | Run build command (`:Build`) |

### Telescope (fuzzy finder)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (includes hidden) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |

Ignored in pickers: `node_modules`, `.git/`, `dist/`.

### Harpoon (quick file switching)

| Key | Action |
|-----|--------|
| `<leader>a` | Add current file to harpoon list |
| `<C-e>` | Toggle harpoon quick menu |
| `<leader>1` | Jump to harpooned file 1 |
| `<leader>2` | Jump to harpooned file 2 |
| `<leader>3` | Jump to harpooned file 3 |
| `<leader>4` | Jump to harpooned file 4 |

### Fugitive (git commands)

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status |
| `<leader>gd` | Git diff split |
| `<leader>gb` | Git blame |
| `<leader>gl` | Git log (oneline) |
| `<leader>gc` | Prompt for message, then `git add . && git commit` |
| `<leader>gp` | Git push |

Also available: `:Git` / `:G <command>` for any git operation.

### Gitsigns (git hunks)

| Key | Mode | Action |
|-----|------|--------|
| `]h` | n | Next hunk |
| `[h` | n | Previous hunk |
| `<leader>hs` | n/v | Stage hunk (or selection) |
| `<leader>hr` | n/v | Reset hunk (or selection) |
| `<leader>hu` | n | Undo stage hunk |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame current line (full) |
| `<leader>hd` | n | Diff this file |

### LSP (active when a language server attaches)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>e` | Show diagnostic (float) |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

`ruff`'s hover is disabled so `basedpyright` owns hover for Python.

### Completion (nvim-cmp, insert mode)

| Key | Action |
|-----|--------|
| `<C-n>` | Select next item |
| `<C-p>` | Select previous item |
| `<C-d>` | Scroll docs up |
| `<C-f>` | Scroll docs down |
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<Tab>` | Next item / expand snippet / fallback |
| `<S-Tab>` | Previous item / jump snippet back / fallback |

Note: `<C-Space>` and `<C-d>` are also used in normal mode (window/scroll). No
conflict — nvim-cmp bindings are insert-mode only.

### Formatting (LSP)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>f` | n | Format buffer via the attached LSP |

All formatting goes through the language server (`vim.lsp.buf.format`). Format on
save is enabled for any attached server that advertises formatting capability
(2000 ms timeout) — install a server via `:MasonInstall` and it participates
automatically, no config needed. When more than one client can format a buffer,
one is chosen deterministically (`format_prefer` in `lsp.lua`; e.g. `ruff` for
Python) so there's no double-format or chooser prompt.

### Autopairs

| Key | Mode | Action |
|-----|------|--------|
| `<M-e>` | i | Fast wrap (surround next word with pair) |

## Custom Commands

| Command | Action |
|---------|--------|
| `:Zen` | Toggle all in-editor diagnostics (virtual text, signs, underlines, floats) on/off |
| `:Build [cmd]` | Run the configured build command; with an argument, set and run it. Output goes to the quickfix list (`:copen`). |
| `:Theme [name]` | Switch color theme profile. Tab-completes `default`, `work`, `home`, `present`. No argument prints the current profile. |

Configure the build command with `:Build make -j8` (inline, sticks for the session)
or `:lua vim.g.build_cmd = "cargo build"`. `.sh` and `.nu` scripts are detected and
run via bash / nu respectively. `<leader>b` runs `:Build` with the current command.

## Themes

Three color profiles, switched live with `:Theme <name>` and configured in
`lua/config/themes.lua`:

| Profile | Colorscheme | Background |
|---------|-------------|------------|
| `default` | stock Neovim `default` | opaque |
| `work` | `carbonfox` (custom nightfox palette) | transparent |
| `home` | forest-green (custom nightfox palette) | transparent |
| `present` | high-contrast light (custom nightfox palette) | opaque |

`work` is the startup profile on this machine (set via `startup` in
`themes.lua`). `present` is a high-contrast light theme (near-black text on
off-white, opaque) tuned to stay legible in screenshots and screen shares. To
add or change a profile, edit `themes.lua` — new entries appear in `:Theme`
tab-completion automatically. The custom palettes live in
`lua/plugins/colorscheme.lua`.

## LSP Servers (auto-installed via Mason)

| Server | Language |
|--------|----------|
| ts_ls | TypeScript / JavaScript |
| lua_ls | Lua |
| basedpyright | Python (types, completions, hover) |
| ruff | Python (linting, formatting) |
| clangd | C / C++ (query-driver pointed at MinGW toolchain) |

`pyright` is explicitly excluded so it never attaches alongside `basedpyright`.

## Notable Options

- Leader / localleader: `Space`
- `tabstop`/`shiftwidth`/`softtabstop` = 4, `expandtab`, `smartindent`
- `number` on, `relativenumber` off
- `hlsearch` off, `incsearch` on, `ignorecase` + `smartcase`
- `termguicolors`, `cursorline`, `scrolloff` = 8, `wrap` off
- `swapfile`/`backup` off, `undofile` on (persistent undo)
- `clipboard = unnamedplus`, system clipboard via `win32yank` on Windows
- `splitright`/`splitbelow`, `mouse = a`, `updatetime` = 50, `timeoutlen` = 300
- On Windows `&shell` is pinned to `cmd.exe` so plugin/git subprocesses don't
  break on the environment's MSYS bash
- Unused providers (python3, node, perl, ruby) disabled
