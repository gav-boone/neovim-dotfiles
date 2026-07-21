#!/bin/bash
# bootstrap.sh — Set up dev environment on a fresh Shakudo session
# Usage: curl -sL https://raw.githubusercontent.com/gav-boone/neovim-dotfiles/main/bootstrap.sh | bash
set -e

echo "=== Installing Neovim ==="
if ! command -v nvim &>/dev/null; then
  curl -LO https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz
  tar -xzf nvim-linux-x86_64.tar.gz -C /opt/
  ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm nvim-linux-x86_64.tar.gz
  echo "  Neovim $(nvim --version | head -1) installed"
else
  echo "  Neovim already installed: $(nvim --version | head -1)"
fi

echo "=== Linking Neovim config ==="
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p ~/.config
ln -sfn "$SCRIPT_DIR/nvim" ~/.config/nvim
echo "  Linked ~/.config/nvim -> $SCRIPT_DIR/nvim"

echo "=== Installing plugins ==="
nvim --headless "+Lazy! sync" +qa 2>/dev/null
echo "  Plugins synced"

echo "=== Adding tmux dev keybinding ==="
if ! grep -q "dev-trio" ~/.tmux.conf 2>/dev/null; then
  cat >> ~/.tmux.conf << 'TMUX'

# --- Dev Trio (Ctrl-b D) — opens kiro, nvim, and shell windows ---
bind D new-window -n kiro 'kiro-cli chat' \; new-window -n nvim 'nvim'
TMUX
  tmux source-file ~/.tmux.conf 2>/dev/null && echo "  Tmux binding added (Ctrl-b D)" || echo "  Tmux config updated (reload with: tmux source ~/.tmux.conf)"
else
  echo "  Tmux dev-trio binding already exists"
fi

echo ""
echo "=== Done! ==="
echo "  • nvim is ready — run 'nvim' to start"
echo "  • Press Ctrl-b D to open kiro + nvim + shell windows"
