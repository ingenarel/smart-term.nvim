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

    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        relative = "editor",
        width = floatingWinWidth,
        height = floatingWinHeight,
        col = math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.shared.floatNeovimXoffset)) / 2),
        row = math.floor((vim.o.lines - floatingWinHeight + (opts.yOffset or m.shared.floatNeovimYoffset)) / 2),
        border = "rounded",
        style = "minimal",
    })

    vim.fn.jobstart(newCommand, {
        term = true,
        on_exit = function()
            if opts.closeOnExit or opts.closeOnExit == nil then
                vim.cmd("q")
            end
            local afterCommand = utils.commandAfterCommands(opts.command)
            if type(afterCommand) == "function" then
                afterCommand()
            end
        end,
    })
    vim.cmd.startinsert()
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

    ---@type integer
    local size

    local sides = {
        below = function()
            size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.shared.splitHeightPercentage))
            return "below"
        end,
        right = function()
            size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.shared.splitWidthPercentage))
            return "right"
        end,
        above = function()
            size = math.floor(vim.o.lines / 100 * (opts.sizePercent or m.shared.splitHeightPercentage))
            return "above"
        end,
        left = function()
            size = math.floor(vim.o.columns / 100 * (opts.sizePercent or m.shared.splitWidthPercentage))
            return "left"
        end,
    }

    utils.directionSubtitution(sides)

    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        split = sides[(opts.side or "below")](),
        style = "minimal",
    })

    vim.cmd.resize(size)

    vim.fn.jobstart(newCommand, {
        term = true,
        on_exit = function()
            if opts.closeOnExit or opts.closeOnExit == nil then
                vim.cmd("q")
            end
            local afterCommand = utils.commandAfterCommands(opts.command)
            if type(afterCommand) == "function" then
                afterCommand()
            end
        end,
    })
    vim.cmd.startinsert()
end -- }}}

return m
