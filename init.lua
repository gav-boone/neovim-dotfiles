-- init.lua — Neovim config with lazy.nvim plugin manager

-- ============================================
-- BOOTSTRAP LEADER KEY
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

-- ============================================
-- LEADER KEY
-- ============================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================
-- CORE OPTIONS
-- ============================================
local opt = vim.opt

-- Shell (use bash when running from Git Bash)
if vim.fn.executable('bash') == 1 and vim.fn.has('win32') == 1 then
    opt.shell = 'bash'
    opt.shellcmdflag = '-c'
    opt.shellquote = ''
    opt.shellxquote = ''
end

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false

-- Behavior
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.clipboard = "unnamedplus"

-- Use win32yank directly for the system clipboard. Pinning the provider avoids
-- the custom `shell=bash` settings above interfering with clipboard calls on
-- native Windows nvim. win32yank ships in nvim-win64/bin (on PATH).
if vim.fn.executable("win32yank.exe") == 1 then
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end

opt.splitright = true
opt.splitbelow = true
opt.mouse = "a"
opt.updatetime = 50
opt.timeoutlen = 300

-- ============================================
-- KEYMAPS
-- ============================================
local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Quick save
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Better paste
map("x", "<leader>p", '"_dP', { desc = "Paste without overwrite" })

-- Quick close
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })

-- ============================================
-- CUSTOM COMMANDS
-- ============================================

-- :Zen — quiet all in-editor warnings/diagnostics.
-- Toggles LSP/diagnostic virtual text, signs, underlines, and floats off.
-- Run :Zen again to turn them back on.
do
    local diagnostics_on = true
    vim.api.nvim_create_user_command("Zen", function()
        diagnostics_on = not diagnostics_on
        if diagnostics_on then
            vim.diagnostic.enable()
            vim.notify("Zen off — diagnostics enabled", vim.log.levels.INFO)
        else
            vim.diagnostic.enable(false)
            vim.notify("Zen on — diagnostics quieted", vim.log.levels.INFO)
        end
    end, { desc = "Toggle all in-editor warnings/diagnostics" })
end

-- :Build — run your build script.
-- Configure the command it runs with :set (it's exposed as a global):
--     :lua vim.g.build_cmd = "cargo build"
-- or set it inline for this session by passing an argument:
--     :Build make -j8
-- With no argument, :Build runs whatever vim.g.build_cmd is set to.
vim.g.build_cmd = vim.g.build_cmd
vim.api.nvim_create_user_command("Build", function(args)
    local cmd = args.args
    if cmd ~= nil and cmd ~= "" then
        -- Inline argument: set it as the new default and run it.
        vim.g.build_cmd = cmd
    else
        cmd = vim.g.build_cmd
    end

    if cmd == nil or cmd == "" then
        vim.notify(
            "No build command set. Use :Build <cmd> or :lua vim.g.build_cmd = '<cmd>'",
            vim.log.levels.ERROR
        )
        return
    end

    vim.notify("Building: " .. cmd, vim.log.levels.INFO)
    -- Run the build and send output to the quickfix list so errors are
    -- navigable with :copen and ]q / [q.
    local output = vim.fn.systemlist(cmd)
    vim.fn.setqflist({}, " ", { title = "Build: " .. cmd, lines = output })
    if vim.v.shell_error ~= 0 then
        vim.cmd("copen")
        vim.notify("Build failed (exit " .. vim.v.shell_error .. ")", vim.log.levels.ERROR)
    else
        vim.notify("Build succeeded", vim.log.levels.INFO)
    end
end, {
    nargs = "*",
    complete = "shellcmd",
    desc = "Run the configured build script (set via vim.g.build_cmd or :Build <cmd>)",
})

-- ============================================
-- DISABLE UNUSED PROVIDERS
-- ============================================
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- ============================================
-- PLUGINS
-- ============================================
require("lazy").setup("plugins", {
    rocks = { enabled = false },
    git = {
        filter = true,
    },
    concurrency = 16,
})
