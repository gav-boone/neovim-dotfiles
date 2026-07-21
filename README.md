# neovim-dotfiles

Personal Neovim config and dev environment bootstrap for Shakudo sessions.

## Quick Setup

```bash
git clone https://github.com/gav-boone/neovim-dotfiles.git ~/dotfiles
cd ~/dotfiles && chmod +x bootstrap.sh && ./bootstrap.sh
```

## What's Included

- **Neovim config** (`nvim/`) — lazy.nvim, tokyonight, telescope, treesitter, LSP, completion, gitsigns, lualine, which-key
- **bootstrap.sh** — installs neovim, links config, syncs plugins, adds tmux keybinding

## Key Bindings

Leader key is `Space`.

| Key | Action |
|-----|--------|
| `Space ff` | Find files (telescope) |
| `Space fg` | Grep text in project |
| `Space fb` | Switch open buffers |
| `Space e` | Toggle file explorer |
| `Space w` | Save file |
| `Space q` | Close window |
| `gd` | Go to definition (LSP) |
| `gr` | Find references (LSP) |
| `K` | Hover docs (LSP) |
| `Space rn` | Rename symbol |
| `Space ca` | Code action |
| `gcc` | Toggle comment (line) |
| `Ctrl-d/u` | Scroll down/up (centered) |

## tmux Dev Trio

`Ctrl-b D` opens three windows: kiro, nvim, and shell.
