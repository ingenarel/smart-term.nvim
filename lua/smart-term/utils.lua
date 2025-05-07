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

return m
