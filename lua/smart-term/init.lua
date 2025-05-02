local m = {}

function m.commandExtraCommands(command) -- {{{
    if command == nil then
        return os.getenv("SHELL")
    end

    local commands = {
        lazygit = function()
            vim.cmd("w")
            print("lazygit: " .. command)
            return command
        end,
        default = function()
            print("default: " .. command)
            return command
        end,
    }

    local fn = commands[command] or commands.default
    return fn()
end -- }}}

function m.openNeovimFloaTerm(opts) -- {{{
    -- vim.print(opts)
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end
    -- vim.print(opts)

    -- print(opts.command)

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    -- print(opts.command)

    ---@type integer
    local floatingWinWidth = math.floor(vim.o.columns / 100 * (opts.widthPercentage or m.widthPercentage))
    ---@type integer
    local floatingWinHeight = math.floor(vim.o.lines / 100 * (opts.heightPercentage or m.heightPercentage))

    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        relative = "editor",
        width = floatingWinWidth,
        height = floatingWinHeight,
        col = math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.neovimXoffset)) / 2),
        row = math.floor((vim.o.lines - floatingWinHeight + (opts.yOffset or m.neovimYoffset)) / 2),
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
    local floatingWinWidth = math.floor(vim.o.columns / 100 * (opts.widthPercentage or m.widthPercentage))
    ---@type integer
    local floatingWinHeight = math.floor(vim.o.lines / 100 * (opts.heightPercentage or m.heightPercentage))

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    local execute = {
        "tmux",
        "display-popup",
        "-w",
        tostring(floatingWinWidth),
        "-h",
        tostring(floatingWinHeight),
        "-x",
        tostring(math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.tmuxXoffset)) / 2)),
        "-y",
        tostring(math.floor((vim.o.lines + floatingWinHeight + (opts.yOffset or m.tmuxYoffset)) / 2)),
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
    local floatingWinWidth = math.floor(vim.o.columns / 100 * (opts.widthPercentage or m.widthPercentage))
    ---@type integer
    local floatingWinHeight = math.floor(vim.o.lines / 100 * (opts.heightPercentage or m.heightPercentage))
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
        tostring(math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.zellijXoffset)) / 2)),
        "-y",
        tostring(math.floor((vim.o.lines - floatingWinHeight + (opts.yOffset or m.zellijYoffset)) / 2)),
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
    -- vim.print(opts)

    -- print(opts.command)

    opts.command = m.commandExtraCommands(opts.command or opts[1])

    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        -- width = floatingWinWidth,
        height = opts.height,
        split = opts.side,
        width = opts.width,
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

function m.setup(opts) -- {{{
    opts = opts or {}

    m.heightPercentage = opts.heightPercentage or 70
    m.widthPercentage = opts.widthPercentage or 80

    m.neovimXoffset = opts.neovimXoffset or -2
    m.neovimYoffset = opts.neovimYoffset or -2

    m.tmuxXoffset = opts.tmuxXoffset or -2
    m.tmuxYoffset = opts.tmuxYoffset or -2

    m.zellijXoffset = opts.zellijXoffset or -2
    m.zellijYoffset = opts.zellijYoffset or 2
end

return m -- }}}
