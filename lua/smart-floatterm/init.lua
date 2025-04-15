local m = {}

function m.openNeovimTerm(command)
	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * m.heightPercentage)
	---@type integer
	local bufID = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(bufID, true, {
		relative = "editor",
		width = floatingWinWidth,
		height = floatingWinHeight,
		col = math.floor((vim.o.columns - floatingWinWidth + m.neovimXoffset) / 2),
		row = math.floor((vim.o.lines - floatingWinHeight + m.neovimYoffset) / 2),
		border = "rounded",
		style = "minimal",
	})
	vim.cmd.term(command)
end

function m.openTmuxTerm(command, closeOnExit)
	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * m.heightPercentage)
	local execute = {
		"tmux",
		"display-popup",
		"-w",
		tostring(floatingWinWidth),
		"-h",
		tostring(floatingWinHeight),
		"-x",
		tostring(math.floor((vim.o.columns - floatingWinWidth + m.tmuxXoffset) / 2)),
		"-y",
		tostring(math.floor((vim.o.lines + floatingWinHeight + m.tmuxYoffset) / 2)),
		"-d",
		vim.fn.getcwd(),
		command,
	}
	if closeOnExit == true or closeOnExit == nil then
		table.insert(execute, 3, "-E")
	end
	vim.system(execute)
end

function m.openZellijTerm(command, closeOnExit)
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
	if command ~= nil then
		table.insert(execute, "--")
		table.insert(execute, command)
	end

	if closeOnExit == true or closeOnExit == nil then
		table.insert(execute, 4, "--close-on-exit")
	end

	vim.system(execute)
end

function m.open(command, closeOnExit)
	if os.getenv("TMUX") then
		m.openTmuxTerm(command, closeOnExit)
	elseif os.getenv("ZELLIJ") then
		m.openZellijTerm(command, closeOnExit)
	else
		--TOOD: figure out how to make neovim work with closeOnExit
		m.openNeovimTerm(command)
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
