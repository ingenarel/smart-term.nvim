local m = {}

local yaziFile = vim.fn.stdpath("cache") .. "/last-yazi-file"

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
            return "yazi --chooser-file " .. yaziFile
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
            if vim.fn.filereadable(yaziFile) == 1 then
                for line in io.lines(yaziFile) do
                    vim.cmd.e(line)
                end
                os.remove(yaziFile)
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
