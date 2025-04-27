local m = {}

function m.openNeovimTerm(opts)
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

    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        relative = "editor",
        width = floatingWinWidth,
        height = floatingWinHeight,
        col = math.floor((vim.o.columns - floatingWinWidth + (opts.xOffset or m.neovimXoffset)) / 2),
        row = math.floor((vim.o.lines - floatingWinHeight + (opts.yOffset or m.neovimYoffset)) / 2),
        border = "rounded",
        style = "minimal",
    })
    vim.cmd.term(opts.command or opts[1])
end

function m.openTmuxTerm(opts)
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
        opts.command or opts[1],
    }
    if opts.closeOnExit == true or opts.closeOnExit == nil then
        table.insert(execute, 3, "-E")
    end
    vim.system(execute)
end

function m.openZellijTerm(opts)
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

    if opts.command ~= nil or opts[1] ~= nil then
        table.insert(execute, "--")
        table.insert(execute, opts.command or opts[1])
    end

    if opts.closeOnExit == true or opts.closeOnExit == nil then
        table.insert(execute, 4, "--close-on-exit")
    end

    vim.system(execute)
end

function m.open(opts)
    if type(opts) == "string" then
        local x = {}
        x[1] = opts
        opts = x
        x = nil
    elseif type(opts) ~= "table" then
        opts = {}
    end

    if os.getenv("TMUX") then
        m.openTmuxTerm {
            command = opts.command or opts[1],
            closeOnExit = opts.closeOnExit,
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
        }
    elseif os.getenv("ZELLIJ") then
        m.openZellijTerm {
            command = opts.command or opts[1],
            closeOnExit = opts.closeOnExit,
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
        }
    else
        --TOOD: figure out how to make neovim work with opts.closeOnExit
        m.openNeovimTerm {
            command = opts.command or opts[1],
            heightPercentage = opts.heightPercentage,
            widthPercentage = opts.widthPercentage,
            xOffset = opts.xOffset,
            yOffset = opts.yOffset,
        }
    end
end

function m.setup(opts)
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

return m
