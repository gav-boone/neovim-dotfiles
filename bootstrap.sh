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

echo "=== Installing dependencies ==="
if ! command -v rg &>/dev/null || ! command -v fdfind &>/dev/null; then
  apt-get update -qq && apt-get install -y -qq ripgrep fd-find >/dev/null 2>&1
  ln -sf "$(which fdfind)" /usr/local/bin/fd
  echo "  ripgrep $(rg --version | head -1) installed"
  echo "  fd $(fd --version) installed"
else
  echo "  ripgrep and fd already installed"
fi

echo "=== Linking Neovim config ==="
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p ~/.config
ln -sfn "$SCRIPT_DIR" ~/.config/nvim
echo "  Linked ~/.config/nvim -> $SCRIPT_DIR"

echo "=== Installing plugins ==="
nvim --headless "+Lazy! sync" +qa 2>/dev/null
echo "  Plugins synced"

echo "=== Configuring tmux ==="
# Add focus-events and true color if not present
if ! grep -q "focus-events on" ~/.tmux.conf 2>/dev/null; then
  sed -i '/^set -g escape-time/a set -g focus-events on' ~/.tmux.conf 2>/dev/null || true
  echo "  Added focus-events on"
fi

if ! grep -q "terminal-overrides.*Tc" ~/.tmux.conf 2>/dev/null; then
  # Get the default-terminal value and add Tc override for true color
  TMUX_TERM=$(grep 'default-terminal' ~/.tmux.conf 2>/dev/null | head -1 | grep -oP '"[^"]+"' | tr -d '"')
  TMUX_TERM="${TMUX_TERM:-screen-256color}"
  sed -i "/default-terminal/a set -ga terminal-overrides \",${TMUX_TERM}:Tc\"" ~/.tmux.conf 2>/dev/null || true
  echo "  Added true color (Tc) terminal override"
fi

# Add dev-trio binding if not present
if ! grep -q "dev-trio" ~/.tmux.conf 2>/dev/null; then
  cat >> ~/.tmux.conf << 'TMUX'

# --- Dev Trio (Ctrl-b D) — opens kiro, nvim, and shell windows ---
bind D new-window -n kiro 'kiro-cli chat' \; new-window -n nvim 'nvim'
TMUX
  echo "  Dev-trio binding added (Ctrl-b D)"
fi

tmux source-file ~/.tmux.conf 2>/dev/null && echo "  Tmux config reloaded" || echo "  Tmux config updated (reload with: tmux source ~/.tmux.conf)"

echo ""
echo "=== Done! ==="
echo "  • nvim is ready — run 'nvim' to start"
echo "  • Press Ctrl-b D to open kiro + nvim + shell windows"
