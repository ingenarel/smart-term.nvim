local m = {}

function m.openNeovimTerm(opts)
	opts = opts or {}
	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * m.heightPercentage)
	---@type integer
	vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
		relative = "editor",
		width = floatingWinWidth,
		height = floatingWinHeight,
		col = math.floor((vim.o.columns - floatingWinWidth + m.neovimXoffset) / 2),
		row = math.floor((vim.o.lines - floatingWinHeight + m.neovimYoffset) / 2),
		border = "rounded",
		style = "minimal",
	})
	vim.cmd.term(opts.command)
end

function m.openTmuxTerm(opts)
	opts = opts or {}

	opts.heightPercentage = opts.heightPercentage or m.heightPercentage
	opts.widthPercentage = opts.widthPercentage or m.widthPercentage

	opts.xOffset = opts.xOffset or m.tmuxXoffset
	opts.yOffset = opts.yOffset or m.tmuxYoffset

	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * opts.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * opts.heightPercentage)
	local execute = {
		"tmux",
		"display-popup",
		"-w",
		tostring(floatingWinWidth),
		"-h",
		tostring(floatingWinHeight),
		"-x",
		tostring(math.floor((vim.o.columns - floatingWinWidth + opts.xOffset) / 2)),
		"-y",
		tostring(math.floor((vim.o.lines + floatingWinHeight + opts.yOffset) / 2)),
		"-d",
		vim.fn.getcwd(),
		"-b",
		"rounded",
		opts.command,
	}
	if opts.closeOnExit == true or opts.closeOnExit == nil then
		table.insert(execute, 3, "-E")
	end
	vim.system(execute)
end

function m.openZellijTerm(opts)
	opts = opts or {}
	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * m.heightPercentage)
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
		tostring(math.floor((vim.o.columns - floatingWinWidth + m.zellijXoffset) / 2)),
		"-y",
		tostring(math.floor((vim.o.lines - floatingWinHeight + m.zellijYoffset) / 2)),
	}
	if opts.command ~= nil then
		table.insert(execute, "--")
		table.insert(execute, opts.command)
	end

	if opts.closeOnExit == true or opts.closeOnExit == nil then
		table.insert(execute, 4, "--close-on-exit")
	end

	vim.system(execute)
end

function m.open(opts)
	opts = opts or {}
	if os.getenv("TMUX") then
		m.openTmuxTerm({
			command = opts.command,
			closeOnExit = opts.closeOnExit,
			heightPercentage = opts.heightPercentage,
			widthPercentage = opts.widthPercentage,
			xOffset = opts.xOffset,
			yOffset = opts.yOffset,
		})
	elseif os.getenv("ZELLIJ") then
		m.openZellijTerm({ command = opts.command, closeOnExit = opts.closeOnExit })
	else
		--TOOD: figure out how to make neovim work with opts.closeOnExit
		m.openNeovimTerm({ command = opts.command })
	end
end

function m.setup(opts)
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
