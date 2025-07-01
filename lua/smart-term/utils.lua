local m = {}

function m.commandExtraCommands(command) -- {{{
    if command == nil then
        return os.getenv("SHELL")
    end

    local commands = {
        lazygit = function()
            vim.cmd("wa")
            return command
        end,
        yazi = function()
            return "yazi --chooser-file " .. vim.fn.stdpath("cache") .. "/last-yazi-file"
        end,
        default = function()
            return command
        end,
    }

    local fn = commands[command] or commands.default
    return fn()
end -- }}}

function m.commandAfterCommands(command) -- {{{
    local commands = {
        lazygit = function()
            vim.cmd.checktime()
        end,
        yazi = function()
            for line in io.lines(vim.fn.stdpath("cache") .. "/last-yazi-file") do
                vim.cmd.e(line)
            end
        end,
    }
    return commands[command]
end -- }}}

function m.directionSubtitution(table)
    table.up = table.above
    table.k = table.above

    table.down = table.below
    table.j = table.below

    table.h = table.left

    table.l = table.right
end

return m
