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
-- TOOLCHAIN ON PATH
-- ============================================
-- Ensure the C toolchain is always visible to nvim, regardless of how nvim was
-- launched (GUI shortcut, terminal, etc.). Required by nvim-treesitter to
-- compile parsers and by telescope-fzf-native's build step. Without this,
-- treesitter reports "No C compiler found" even though gcc/clang are installed.
do
    local tool_bins = {
            "C:\\Users\\gboone\\Programs\\mingw64\\bin",
            "C:\\Users\\gboone\\Programs\\clang+llvm-23.1.4-x86_64-pc-windows-msvc\\bin",
            "C:\\Users\\gboone\\Programs\\node-v24.22.1-win-x64",
        }

    -- Python: the `python` on PATH is the Windows Store 0-byte app-execution
    -- alias, which mason and LSP tooling (pyright/basedpyright) can't resolve
    -- as a real interpreter. The genuine python.exe lives in the WindowsApps
    -- package dir. Resolve it dynamically (the version is in the folder name
    -- and changes on update) and put it ahead of the stub so `python`/`pip`
    -- point at a real executable. Prefers a standard on-disk install if one
    -- exists.
    do
        local candidates = {}
        -- Standard per-user install (if the user ever installs non-Store Python)
        vim.list_extend(candidates, vim.fn.glob(
            vim.fn.expand("$LOCALAPPDATA") .. "\\Programs\\Python\\Python3*", true, true))
        -- Store package real install dir (has a real python.exe, not the alias)
        vim.list_extend(candidates, vim.fn.glob(
            "C:\\Program Files\\WindowsApps\\PythonSoftwareFoundation.Python.3*_x64__*", true, true))
        -- Pick the newest (glob sorts ascending, so take the last match).
        for i = #candidates, 1, -1 do
            local dir = candidates[i]
            if vim.fn.filereadable(dir .. "\\python.exe") == 1 then
                table.insert(tool_bins, dir)
                -- pip-installed console scripts live under Scripts/
                if vim.fn.isdirectory(dir .. "\\Scripts") == 1 then
                    table.insert(tool_bins, dir .. "\\Scripts")
                end
                break
            end
        end
    end

    local sep = ";"
    local path = vim.env.PATH or ""
    for _, dir in ipairs(tool_bins) do
        if vim.fn.isdirectory(dir) == 1 and not path:find(dir, 1, true) then
            path = dir .. sep .. path
        end
    end
    vim.env.PATH = path
end

-- ============================================
-- CORE OPTIONS
-- ============================================
local opt = vim.opt

-- Shell
-- Force a native Windows shell for vim.fn.system()/build commands. The
-- environment here exports SHELL=C:\Program Files\Git\usr\bin\bash.exe (MSYS
-- bash), which nvim would otherwise adopt as &shell. That MSYS bash only works
-- inside the Git-Bash environment; when native nvim drives it for plugin
-- builds (treesitter parser compiles, git clones) it fails with
-- "/usr/bin/bash: No such file or directory". Pinning &shell to cmd.exe keeps
-- all tool subprocesses on a native, working shell.
if vim.fn.has("win32") == 1 then
    opt.shell = "cmd.exe"
    opt.shellcmdflag = "/s /c"
    opt.shellquote = ""
    opt.shellxquote = ""
    opt.shellredir = ">%s 2>&1"
    opt.shellpipe = ">%s 2>&1"
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
    --
    -- &shell is pinned to cmd.exe (so plugin/git subprocesses don't break on
    -- the MSYS bash in this environment). cmd.exe can't execute shell scripts,
    -- so if the build command is (or starts with) a .sh script, run it through
    -- bash explicitly instead of the default shell.
    local run = cmd
    local script = cmd:match("^%s*%.?/?([%w_%-./]+%.sh)") or (cmd:match("%.sh%s*$") and cmd)
    if script then
        local bash = vim.fn.exepath("bash")
        if bash == "" then
            bash = "C:/Program Files/Git/bin/bash.exe"
        end
        -- Invoke via bash -lc so the script's shebang/login PATH apply. Quote
        -- the whole user command for bash -c.
        run = { bash, "-lc", cmd }
    end
    local output = vim.fn.systemlist(run)
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

-- <leader>b — run :Build with the configured build command.
map("n", "<leader>b", "<cmd>Build<CR>", { desc = "Run build command" })

-- ============================================
-- DIAGNOSTICS DISPLAY
-- ============================================
-- On Neovim 0.11+ virtual_text is OFF by default, so diagnostics only show a
-- sign + underline with no inline message text. Turn on virtual_text (the
-- message shown to the right of the line) plus readable floats/signs.
vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        prefix = "●",
        source = "if_many",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
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
