local m = {}

local utils = require("smart-term.utils")

function m.openNeovimFloaTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = utils.commandExtraCommands(opts.command or opts[1])

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
            utils.commandAfterCommands(opts.command)
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

    opts.command = utils.commandExtraCommands(opts.command or opts[1])

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
        utils.commandAfterCommands(opts.command)
    else
        vim.system(execute, {}, function()
            utils.commandAfterCommands(opts.command)
        end)
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

    opts.command = utils.commandExtraCommands(opts.command or opts[1])

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
        utils.commandAfterCommands(opts.command)
    else
        vim.system(execute, {}, function()
            utils.commandAfterCommands(opts.command)
        end)
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

    opts.command = utils.commandExtraCommands(opts.command or opts[1])

    ---@type integer
    local size

    local sides = {
        below = function()
            size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.splitHeightPercentage))
            return "below"
        end,
        right = function()
            size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.splitWidthPercentage))
            return "right"
        end,
        above = function()
            size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.splitHeightPercentage))
            return "above"
        end,
        left = function()
            size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.splitWidthPercentage))
            return "left"
        end,
    }

    utils.directionSubtitution(sides)

    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        split = sides[(opts.side or "below")](),
        style = "minimal",
    })

    vim.cmd.resize(size)

    vim.fn.jobstart(opts.command, {
        term = true,
        on_exit = function()
            if opts.closeOnExit or opts.closeOnExit == nil then
                vim.cmd("q")
            end
            utils.commandAfterCommands(opts.command)
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

    opts.command = utils.commandExtraCommands(opts.command or opts[1])

    local execute = {
        "tmux",
        "split-window",
    }

    ---@type integer
    local size

    local sides = {
        below = function()
            table.insert(execute, "-v")
            size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.splitHeightPercentage))
        end,
        right = function()
            table.insert(execute, "-h")
            size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.splitWidthPercentage))
        end,
        above = function()
            table.insert(execute, "-v")
            table.insert(execute, "-b")
            size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.splitHeightPercentage))
        end,
        left = function()
            table.insert(execute, "-h")
            table.insert(execute, "-b")
            size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.splitWidthPercentage))
        end,
    }

    utils.directionSubtitution(sides)

    sides[(opts.side or "below")]()

    table.insert(execute, "-l")
    table.insert(execute, size)

    table.insert(execute, opts.command)

    if opts.stopVim then
        vim.system(execute):wait()
        utils.commandAfterCommands(opts.command)
    else
        vim.system(execute, {}, function()
            utils.commandAfterCommands(opts.command)
        end)
    end
end -- }}}

function m.openZellijSpliTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = utils.commandExtraCommands(opts.command or opts[1])

    print(opts.command)

    local execute = {
        "sh",
        "-c",
        "zellij action new-pane ",
    }

    --TODO: figure out how to specify custom sizes

    -- ---@type integer
    -- local size

    local sides = {
        below = function()
            execute[3] = execute[3] .. "--direction=down "
            if opts.closeOnExit or opts.closeOnExit == nil then
                execute[3] = execute[3] .. " --close-on-exit "
            end
            execute[3] = execute[3] .. " -- " .. opts.command
            -- size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.splitHeightPercentage))
        end,
        right = function()
            execute[3] = execute[3] .. " --direction=right "
            if opts.closeOnExit or opts.closeOnExit == nil then
                execute[3] = execute[3] .. " --close-on-exit "
            end
            execute[3] = execute[3] .. " -- " .. opts.command
            -- size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.splitWidthPercentage))
        end,
        above = function()
            execute[3] = execute[3] .. " --direction=down "
            if opts.closeOnExit or opts.closeOnExit == nil then
                execute[3] = execute[3] .. " --close-on-exit "
            end
            execute[3] = execute[3] .. " -- " .. opts.command .. " && zellij action move-pane up"
            -- size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.splitHeightPercentage))
        end,
        left = function()
            execute[3] = execute[3] .. " --direction=right "
            if opts.closeOnExit or opts.closeOnExit == nil then
                execute[3] = execute[3] .. " --close-on-exit "
            end
            execute[3] = execute[3] .. " -- " .. opts.command .. " && zellij action move-pane left"
            -- size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.splitWidthPercentage))
        end,
    }

    utils.directionSubtitution(sides)

    sides[(opts.side or "below")]()

    if opts.stopVim then
        vim.system(execute):wait()
        utils.commandAfterCommands(opts.command)
    else
        vim.system(execute, {}, function()
            utils.commandAfterCommands(opts.command)
        end)
    end
end -- }}}

function m.openSpliTerm(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    if os.getenv("TMUX") then
        m.openTmuxSpliTerm {
            command = opts.command,
            side = opts.side,
            closeOnExit = opts.closeOnExit,
            sizePercent = opts.sizePercent,
            stopVim = opts.stopVim,
        }
    elseif os.getenv("ZELLIJ") then
        m.openZellijSpliTerm {
            command = opts.command,
            side = opts.side,
            closeOnExit = opts.closeOnExit,
            stopVim = opts.stopVim,
        }
    else
        m.openNeovimSpliTerm {
            command = opts.command,
            side = opts.side,
            size = opts.size,
            closeOnExit = opts.closeOnExit,
        }
    end
end -- }}}

function m.setup(opts) -- {{{
    opts = opts or {}

    m.floatHeightPercentage = opts.floatHeightPercentage or 70
    m.floatWidthPercentage = opts.floatWidthPercentage or 80

    m.splitHeightPercentage = opts.splitHeightPercentage or 33
    m.splitWidthPercentage = opts.splitWidthPercentage or 33

    m.floatNeovimXoffset = opts.floatNeovimXoffset or -2
    m.floatNeovimYoffset = opts.floatNeovimYoffset or -2

    m.floatTmuxXoffset = opts.floatTmuxXoffset or -2
    m.floatTmuxYoffset = opts.floatTmuxYoffset or -2

    m.floatZellijXoffset = opts.floatZellijXoffset or -2
    m.floatZellijYoffset = opts.floatZellijYoffset or 2
end -- }}}

return m
