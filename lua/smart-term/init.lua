---@type smartTerm.init
local m = {
    ---@diagnostic disable-next-line: missing-fields
    shared = {},
}

function m.open(opts) -- {{{
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    opts.command = opts[1] or opts.command

    local functions = {
        tmux = function()
            if os.getenv("TMUX") then
                local tmux = require("smart-term.tmux")
                return { float = tmux.float, split = tmux.split }
            end
        end,
        zellij = function()
            if os.getenv("ZELLIJ") then
                local zellij = require("smart-term.zellij")
                return { float = zellij.float, spit = zellij.split }
            end
        end,
        nvim = function()
            local nvim = require("smart-term.neovim")
            return { float = nvim.float, split = nvim.split }
        end,
    }

    opts.choices = opts.choices or { "tmux", "zellij", "nvim" }
    for _, choice in ipairs(opts.choices) do
        local func = functions[choice]()
        if func then
            if opts.float then
                func.float(opts)
            elseif opts.split then
                func.split(opts)
            end
            break
        end
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
