# neovim-dotfiles

Personal Neovim config and dev environment bootstrap for Shakudo sessions.

## Quick Setup

```bash
git clone https://github.com/gav-boone/neovim-dotfiles.git ~/dotfiles
cd ~/dotfiles && chmod +x bootstrap.sh && ./bootstrap.sh
```

## Plugins

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) | Colorscheme (carbonfox) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF sorter for telescope |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & incremental selection |
| [harpoon2](https://github.com/ThePrimeagen/harpoon) | Quick file navigation |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git commands in vim |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter, hunk actions |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library (dependency) |

## Key Bindings

Leader key is `Space`.

### General

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit window |
| `<Esc>` | Clear search highlights |
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-d>` | Scroll down (centered) |
| `<C-u>` | Scroll up (centered) |
| `J` (visual) | Move selection down |
| `K` (visual) | Move selection up |
| `<leader>p` (visual) | Paste without overwriting register |

### Telescope (fuzzy finder)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |

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
| `<leader>gc` | Git commit with message |

Also available: `:Git <command>` for any git operation.

### Gitsigns (git hunks)

| Key | Action |
|-----|--------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>hs` | Stage hunk (normal or visual) |
| `<leader>hr` | Reset hunk (normal or visual) |
| `<leader>hu` | Undo stage hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame current line (full) |
| `<leader>hd` | Diff this file |

### Treesitter (incremental selection)

| Key | Action |
|-----|--------|
| `<C-space>` | Init/expand selection |
| `<BS>` | Shrink selection |

## Treesitter Languages

lua, typescript, tsx, javascript, python, json, html, css, bash, markdown

## tmux Dev Trio

`Ctrl-b D` opens three windows: kiro, nvim, and shell.
