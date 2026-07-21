-- init.lua — Neovim configuration
-- Structure: this file sets core options and keymaps, then loads plugins via lazy.nvim

-- ============================================
-- LEADER KEY (set before plugins load)
-- ============================================
-- Space as leader key — most modern configs use this.
-- Press space, then another key to trigger commands.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================
-- CORE OPTIONS
-- ============================================
local opt = vim.opt

-- Line numbers
opt.number = true         -- show line numbers
opt.relativenumber = true -- relative numbers (makes jumping easier: 5j, 12k)

-- Tabs & indentation
opt.tabstop = 2           -- tab displays as 2 spaces
opt.shiftwidth = 2        -- indent by 2 spaces
opt.expandtab = true      -- use spaces, not tabs
opt.smartindent = true    -- auto-indent new lines

-- Search
opt.ignorecase = true     -- case-insensitive search...
opt.smartcase = true      -- ...unless you type a capital letter
opt.hlsearch = false      -- don't keep highlighting after search
opt.incsearch = true      -- show matches as you type

-- Appearance
opt.termguicolors = true  -- true color support
opt.signcolumn = "yes"    -- always show sign column (avoids text shifting)
opt.cursorline = true     -- highlight current line
opt.scrolloff = 8         -- keep 8 lines visible above/below cursor
opt.wrap = false          -- don't wrap long lines

-- Behavior
opt.swapfile = false      -- no swap files
opt.backup = false        -- no backup files
opt.undofile = true       -- persistent undo (survives closing file)
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.clipboard = "unnamedplus" -- use system clipboard
opt.splitright = true     -- vertical splits open to the right
opt.splitbelow = true     -- horizontal splits open below
opt.mouse = "a"           -- enable mouse (useful while learning)
opt.updatetime = 250      -- faster CursorHold events (for LSP)
opt.timeoutlen = 300      -- faster key sequence completion

-- ============================================
-- KEYMAPS
-- ============================================
local map = vim.keymap.set

-- Better window navigation (Ctrl + h/j/k/l to move between splits)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Quick save
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Clear search highlighting (just press Escape)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Better paste (don't overwrite register when pasting over selection)
map("x", "<leader>p", '"_dP', { desc = "Paste without overwrite" })

-- Quick close buffer
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })

-- ============================================
-- BOOTSTRAP LAZY.NVIM (plugin manager)
-- ============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from lua/plugins/ directory
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})
