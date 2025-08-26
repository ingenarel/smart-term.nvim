---@type smartTerm.init
local m = {
    ---@diagnostic disable-next-line: missing-fields
    shared = {},
}

function m.float(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = opts[1] or opts.command

    if os.getenv("TMUX") then
        require("smart-term.tmux").float {
            command = opts.command,
            closeOnExit = opts.closeOnExit,
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
            stopVim = opts.stopVim,
        }
    elseif os.getenv("ZELLIJ") then
        require("smart-term.zellij").float {
            command = opts.command,
            closeOnExit = opts.closeOnExit,
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
            stopVim = opts.stopVim,
        }
    else
        require("smart-term.neovim").float {
            command = opts.command,
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
            closeOnExit = opts.closeOnExit,
        }
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

    opts.command = opts[1] or opts.command

    if os.getenv("TMUX") then
        require("smart-term.tmux").split {
            command = opts.command,
            side = opts.side,
            closeOnExit = opts.closeOnExit,
            sizePercent = opts.sizePercent,
            stopVim = opts.stopVim,
        }
    elseif os.getenv("ZELLIJ") then
        require("smart-term.zellij").split {
            command = opts.command,
            side = opts.side,
            closeOnExit = opts.closeOnExit,
            stopVim = opts.stopVim,
        }
    else
        require("smart-term.neovim").split {
            command = opts.command,
            side = opts.side,
            size = opts.size,
            closeOnExit = opts.closeOnExit,
        }
    end
end -- }}}

function m.setup(opts) -- {{{
    opts = opts or {}

    m.shared.floatHeightPercentage = opts.floatHeightPercentage or 70
    m.shared.floatWidthPercentage = opts.floatWidthPercentage or 80

    m.shared.splitHeightPercentage = opts.splitHeightPercentage or 33
    m.shared.splitWidthPercentage = opts.splitWidthPercentage or 33

    m.shared.floatNeovimXoffset = opts.floatNeovimXoffset or -2
    m.shared.floatNeovimYoffset = opts.floatNeovimYoffset or -2

    m.shared.floatTmuxXoffset = opts.floatTmuxXoffset or -2
    m.shared.floatTmuxYoffset = opts.floatTmuxYoffset or -2

    m.shared.floatZellijXoffset = opts.floatZellijXoffset or -2
    m.shared.floatZellijYoffset = opts.floatZellijYoffset or 2
end -- }}}

return m
