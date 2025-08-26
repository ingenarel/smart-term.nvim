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

    opts.command = opts.command or opts[1]
    local newCommand = utils.commandExtraCommands(opts.command)

    ---@type integer
    local floatingWinWidth = math.floor(vim.o.columns / 100 * (opts.widthPercentage or m.shared.floatWidthPercentage))
    ---@type integer
    local floatingWinHeight = math.floor(vim.o.lines / 100 * (opts.heightPercentage or m.shared.floatHeightPercentage))
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
        tostring(math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.shared.floatZellijXoffset)) / 2)),
        "-y",
        tostring(math.floor((vim.o.lines - floatingWinHeight + (opts.yOffset or m.shared.floatZellijYoffset)) / 2)),
    }

    if opts.closeOnExit or opts.closeOnExit == nil then
        table.insert(execute, 4, "--close-on-exit")
    end

    table.insert(execute, "--")
    for command in vim.gsplit(newCommand, " ") do
        table.insert(execute, command)
    end

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
            execute[3] = execute[3] .. " -- " .. newCommand
            -- size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.shared.splitHeightPercentage))
        end,
        right = function()
            execute[3] = execute[3] .. " --direction=right "
            if opts.closeOnExit or opts.closeOnExit == nil then
                execute[3] = execute[3] .. " --close-on-exit "
            end
            execute[3] = execute[3] .. " -- " .. newCommand
            -- size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.shared.splitWidthPercentage))
        end,
        above = function()
            execute[3] = execute[3] .. " --direction=down "
            if opts.closeOnExit or opts.closeOnExit == nil then
                execute[3] = execute[3] .. " --close-on-exit "
            end
            execute[3] = execute[3] .. " -- " .. newCommand .. " && zellij action move-pane up"
            -- size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.shared.splitHeightPercentage))
        end,
        left = function()
            execute[3] = execute[3] .. " --direction=right "
            if opts.closeOnExit or opts.closeOnExit == nil then
                execute[3] = execute[3] .. " --close-on-exit "
            end
            execute[3] = execute[3] .. " -- " .. newCommand .. " && zellij action move-pane left"
            -- size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.shared.splitWidthPercentage))
        end,
    }

    utils.directionSubtitution(sides)

    sides[(opts.side or "below")]()

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
