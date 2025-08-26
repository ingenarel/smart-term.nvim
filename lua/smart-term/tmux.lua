local m = {
    shared = require("smart-term").shared,
}

local utils = require("smart-term.utils")

function m.float(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    ---@type integer
    local floatingWinWidth = math.floor(vim.o.columns / 100 * (opts.widthPercentage or m.shared.floatWidthPercentage))
    ---@type integer
    local floatingWinHeight = math.floor(vim.o.lines / 100 * (opts.heightPercentage or m.shared.floatHeightPercentage))

    opts.command = opts.command or opts[1]
    local newCommand = utils.commandExtraCommands(opts.command)

    local execute = {
        "tmux",
        "display-popup",
        "-w",
        tostring(floatingWinWidth),
        "-h",
        tostring(floatingWinHeight),
        "-x",
        tostring(math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.shared.floatTmuxXoffset)) / 2)),
        "-y",
        tostring(math.floor((vim.o.lines + floatingWinHeight + (opts.yOffset or m.shared.floatTmuxYoffset)) / 2)),
        "-d",
        vim.fn.getcwd(),
        "-b",
        "rounded",
        "tmux attach -t 'neovimscratch' > /dev/null 2>&1 || tmux new-session -s 'neovimscratch' '" .. newCommand,
    }
    if opts.closeOnExit or opts.closeOnExit == nil then
        table.insert(execute, 3, "-E")
    else
        execute[#execute] = execute[#execute]
            .. ' ; printf "\\n\\n\\n"; echo "Process ended with exit code of $?"; echo "Please press enter to continue"; read'
    end
    execute[#execute] = execute[#execute] .. "'"

    local afterCommand = utils.commandAfterCommands(opts.command)
    if type(afterCommand) == "function" then
        opts.stopVim = true
    end
    if opts.stopVim then
        vim.system(execute):wait()
        afterCommand()
    else
        vim.system(execute)
    end
end -- }}}

function m.split(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = opts.command or opts[1]
    local newCommand = utils.commandExtraCommands(opts.command)

    local execute = {
        "tmux",
        "split-window",
    }

    ---@type integer
    local size

    local sides = {
        below = function()
            table.insert(execute, "-v")
            size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.shared.splitHeightPercentage))
        end,
        right = function()
            table.insert(execute, "-h")
            size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.shared.splitWidthPercentage))
        end,
        above = function()
            table.insert(execute, "-v")
            table.insert(execute, "-b")
            size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.shared.splitHeightPercentage))
        end,
        left = function()
            table.insert(execute, "-h")
            table.insert(execute, "-b")
            size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.shared.splitWidthPercentage))
        end,
    }

    utils.directionSubtitution(sides)

    sides[(opts.side or "below")]()

    table.insert(execute, "-l")
    table.insert(execute, size)

    table.insert(execute, newCommand)

    local afterCommand = utils.commandAfterCommands(opts.command)
    if type(afterCommand) == "function" then
        opts.stopVim = true
    end
    if opts.stopVim then
        vim.system(execute):wait()
        afterCommand()
    else
        vim.system(execute)
    end
end -- }}}

return m
