-- Per-project format/build commands, read from a `.nvimproject` file.
--
-- Example `.nvimproject` (at the project root):
--
--     # comments start with # or ;
--     [format] sh format.sh
--     [build]  sh build.sh --o0
--
-- A command may also go on the line after the section header:
--
--     [build]
--     sh build.sh --o0
--
-- Only the first command line of each section is used. Commands run with the
-- project root (the directory holding `.nvimproject`) as the working directory.
-- In [format], `{file}` expands to the shell-escaped path of the current file.
--
-- Security: the file can run arbitrary commands, so it is read through
-- vim.secure.read(), which asks you to trust it the first time and again
-- whenever its contents change.

local M = {}

local FILENAME = ".nvimproject"

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO)
end

--- Parse file text into { format = "...", build = "..." }.
function M.parse(text)
    local cfg, section = {}, nil
    for line in text:gmatch("[^\r\n]+") do
        line = vim.trim(line)
        if line ~= "" and not line:match("^[#;]") then
            local name, rest = line:match("^%[([%w_]+)%]%s*(.*)$")
            if name then
                section = name:lower()
                if rest ~= "" then
                    cfg[section] = rest
                end
            elseif section and cfg[section] == nil then
                cfg[section] = line
            end
        end
    end
    return cfg
end

--- Directory containing .nvimproject for the current buffer (or cwd).
local function find_root()
    local start = vim.api.nvim_buf_get_name(0)
    if start == "" or vim.bo.buftype ~= "" then
        start = vim.uv.cwd()
    end
    return vim.fs.root(start, FILENAME)
end

--- Load the config for the current buffer. Returns cfg, root (or nil, reason).
local function load()
    local root = find_root()
    if not root then
        return nil, "no " .. FILENAME .. " found"
    end
    local path = vim.fs.joinpath(root, FILENAME)
    local text = vim.secure.read(path)
    if not text then
        return nil, path .. " is not trusted (run :trust to approve it)"
    end
    return M.parse(text), root
end

--- Wrap a command string for the platform shell. No script-type detection:
--- the command is run exactly as written (e.g. `sh build.sh`, `nu build.nu`).
local function argv(cmd)
    if vim.fn.has("win32") == 1 then
        return { "cmd.exe", "/s", "/c", cmd }
    end
    return { "sh", "-c", cmd }
end

local function run(cmd, root, on_done)
    local start = vim.uv.hrtime()
    vim.system(argv(cmd), { cwd = root, text = true }, function(res)
        vim.schedule(function()
            local lines = vim.split((res.stdout or "") .. (res.stderr or ""), "\r?\n", { trimempty = true })
            on_done(res.code, lines, (vim.uv.hrtime() - start) / 1e9)
        end)
    end)
end

--- Shared runner for [build] and [format]: runs the command, times it, puts
--- output in the quickfix list (opened on failure) and reports the duration.
---   label:   "Build" / "Format" (used in titles and messages)
---   verbs:   { start = "Building", ok = "succeeded" } start is optional
---   on_ok:   optional callback after a successful run
local function execute(label, cmd, root, opts)
    opts = opts or {}
    if opts.start then
        notify(opts.start .. ": " .. cmd)
    end
    run(cmd, root, function(code, lines, secs)
        if code ~= 0 or opts.always_qf then
            vim.fn.setqflist({}, " ", { title = label .. ": " .. cmd, lines = lines })
        end
        local took = string.format("%.2fs", secs)
        if code ~= 0 then
            vim.cmd("copen")
            notify(label .. " failed (exit " .. code .. ") in " .. took, vim.log.levels.ERROR)
        else
            notify(label .. " succeeded in " .. took)
            if opts.on_ok then
                opts.on_ok()
            end
        end
    end)
end

function M.build()
    local cfg, root = load()
    if not cfg then
        return notify(root, vim.log.levels.ERROR)
    end
    if not cfg.build then
        return notify("No [build] command in " .. FILENAME, vim.log.levels.ERROR)
    end
    execute("Build", cfg.build, root, { start = "Building", always_qf = true })
end

--- Run [format] against the file on disk, then reload changed buffers.
local function format_now()
    local cfg, root = load()
    if not cfg then
        return -- silent: most files have no project config
    end
    if not cfg.format then
        return
    end
    local file = vim.api.nvim_buf_get_name(0)
    local cmd = cfg.format:gsub("{file}", function()
        return vim.fn.shellescape(file)
    end)
    execute("Format", cmd, root, {
        on_ok = function()
            vim.cmd("checktime")
        end,
    })
end

--- :Format — save (which triggers the format-on-save autocmd) or format directly.
function M.format()
    if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" then
        return notify("Buffer is not a file", vim.log.levels.WARN)
    end
    local cfg, reason = load()
    if not cfg then
        return notify(reason, vim.log.levels.ERROR)
    end
    if not cfg.format then
        return notify("No [format] command in " .. FILENAME, vim.log.levels.ERROR)
    end
    if vim.bo.modified then
        vim.cmd("silent update") -- BufWritePost runs the formatter
    else
        format_now()
    end
end

function M.setup()
    vim.o.autoread = true
    vim.api.nvim_create_user_command("Build", M.build, {
        nargs = 0,
        desc = "Run the [build] command from .nvimproject",
    })
    vim.api.nvim_create_user_command("Format", M.format, {
        nargs = 0,
        desc = "Run the [format] command from .nvimproject",
    })
    vim.keymap.set("n", "<leader>b", "<cmd>Build<CR>", { desc = "Run build command" })
    vim.keymap.set("n", "<leader>f", "<cmd>Format<CR>", { desc = "Run format command" })

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("ProjectFormat", { clear = true }),
        callback = function(ev)
            -- Saving .nvimproject from nvim means you just wrote or reviewed
            -- it, so re-trust the new contents instead of prompting again.
            if vim.fs.basename(ev.file) == FILENAME then
                vim.secure.trust({ action = "allow", bufnr = ev.buf })
            end
            if vim.bo[ev.buf].buftype == "" then
                format_now()
            end
        end,
    })
end

return M
