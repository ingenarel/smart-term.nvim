local m = {}

function m.commandExtraCommands(command) -- {{{
    if command == nil then
        return os.getenv("SHELL")
    end

    local commands = {
        lazygit = function()
            vim.cmd("w")
            return command
        end,
        default = function()
            return command
        end,
    }

    local fn = commands[command] or commands.default
    return fn()
end -- }}}

function m.openNeovimFloaTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    ---@type integer
    local floatingWinWidth = math.floor(vim.o.columns / 100 * (opts.widthPercentage or m.floatWidthPercentage))
    ---@type integer
    local floatingWinHeight = math.floor(vim.o.lines / 100 * (opts.heightPercentage or m.floatHeightPercentage))

    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        relative = "editor",
        width = floatingWinWidth,
        height = floatingWinHeight,
        col = math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.floatNeovimXoffset)) / 2),
        row = math.floor((vim.o.lines - floatingWinHeight + (opts.yOffset or m.floatNeovimYoffset)) / 2),
        border = "rounded",
        style = "minimal",
    })

    vim.fn.jobstart(opts.command, {
        term = true,
        on_exit = function()
            if opts.closeOnExit or opts.closeOnExit == nil then
                vim.cmd("q")
            end
        end,
    })
    vim.cmd.startinsert()
end -- }}}

function m.openTmuxFloaTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    ---@type integer
    local floatingWinWidth = math.floor(vim.o.columns / 100 * (opts.widthPercentage or m.floatWidthPercentage))
    ---@type integer
    local floatingWinHeight = math.floor(vim.o.lines / 100 * (opts.heightPercentage or m.floatHeightPercentage))

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    local execute = {
        "tmux",
        "display-popup",
        "-w",
        tostring(floatingWinWidth),
        "-h",
        tostring(floatingWinHeight),
        "-x",
        tostring(math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.floatTmuxXoffset)) / 2)),
        "-y",
        tostring(math.floor((vim.o.lines + floatingWinHeight + (opts.yOffset or m.floatTmuxYoffset)) / 2)),
        "-d",
        vim.fn.getcwd(),
        "-b",
        "rounded",
        opts.command,
    }
    if opts.closeOnExit or opts.closeOnExit == nil then
        table.insert(execute, 3, "-E")
    end

    if opts.stopVim then
        vim.system(execute):wait()
    else
        vim.system(execute)
    end
end -- }}}

function m.openZellijFloaTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    ---@type integer
    local floatingWinWidth = math.floor(vim.o.columns / 100 * (opts.widthPercentage or m.floatWidthPercentage))
    ---@type integer
    local floatingWinHeight = math.floor(vim.o.lines / 100 * (opts.heightPercentage or m.floatHeightPercentage))
    local execute = {
        "zellij",
        "action",
        "new-pane",
        "--floating",
        "--width",
        tostring(floatingWinWidth),
        "--height",
        tostring(floatingWinHeight),
        "-x",
        tostring(math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.floatZellijXoffset)) / 2)),
        "-y",
        tostring(math.floor((vim.o.lines - floatingWinHeight + (opts.yOffset or m.floatZellijYoffset)) / 2)),
    }

    if opts.closeOnExit or opts.closeOnExit == nil then
        table.insert(execute, 4, "--close-on-exit")
    end

    table.insert(execute, "--")
    table.insert(execute, opts.command)

    if opts.stopVim then
        vim.system(execute):wait()
    else
        vim.system(execute)
    end
end -- }}}

function m.openFloaTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    if os.getenv("TMUX") then
        m.openTmuxFloaTerm {
            command = opts.command,
            closeOnExit = opts.closeOnExit,
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
            stopVim = opts.stopVim,
        }
    elseif os.getenv("ZELLIJ") then
        m.openZellijFloaTerm {
            command = opts.command,
            closeOnExit = opts.closeOnExit,
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
            stopVim = opts.stopVim,
        }
    else
        m.openNeovimFloaTerm {
            command = opts.command,
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
            closeOnExit = opts.closeOnExit,
        }
    end
end -- }}}

function m.openNeovimSpliTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        split = opts.side or "below",
        style = "minimal",
    })

    vim.cmd.resize(opts.size or 15)

    vim.fn.jobstart(opts.command, {
        term = true,
        on_exit = function()
            if opts.closeOnExit or opts.closeOnExit == nil then
                vim.cmd("q")
            end
        end,
    })
    vim.cmd.startinsert()
end -- }}}

function m.openTmuxSpliTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    local execute = {
        "tmux",
    }

    table.insert(execute, "split-window")

    if opts.side == "below" or opts.side == nil then
        table.insert(execute, "-v")
    elseif opts.side == "right" then
        table.insert(execute, "-h")
    elseif opts.side == "above" then
        table.insert(execute, "-v")
        table.insert(execute, "-b")
    elseif opts.side == "left" then
        table.insert(execute, "-h")
        table.insert(execute, "-b")
    end

    table.insert(execute, "-l")
    table.insert(execute, opts.size or 15)

    table.insert(execute, opts.command)

    if opts.stopVim then
        vim.system(execute):wait()
    else
        vim.system(execute)
    end
end -- }}}

function m.setup(opts) -- {{{
    opts = opts or {}

    m.floatHeightPercentage = opts.floatHeightPercentage or 70
    m.floatWidthPercentage = opts.floatWidthPercentage or 80

    m.floatNeovimXoffset = opts.floatNeovimXoffset or -2
    m.floatNeovimYoffset = opts.floatNeovimYoffset or -2

    m.floatTmuxXoffset = opts.floatTmuxXoffset or -2
    m.floatTmuxYoffset = opts.floatTmuxYoffset or -2

    m.floatZellijXoffset = opts.floatZellijXoffset or -2
    m.floatZellijYoffset = opts.floatZellijYoffset or 2
end

return m -- }}}
