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
	m.heightPercentage = opts.heightPercentage
	m.widthPercentage = opts.widthPercentage

	m.neovimXoffset = opts.neovimXoffset
	m.neovimYoffset = opts.neovimYoffset

	m.tmuxXoffset = opts.tmuxXoffset
	m.tmuxYoffset = opts.tmuxYoffset

	m.zellijXoffset = opts.zellijXoffset
	m.zellijYoffset = opts.zellijYoffset

	if m.heightPercentage == nil then
		m.heightPercentage = 70
	end
	if m.widthPercentage == nil then
		m.widthPercentage = 80
	end

	if m.neovimXoffset == nil then
		m.neovimXoffset = -2
	end
	if m.neovimYoffset == nil then
		m.neovimYoffset = -2
	end

	if m.tmuxXoffset == nil then
		m.tmuxXoffset = -2
	end
	if m.tmuxYoffset == nil then
		m.tmuxYoffset = -2
	end

	if m.zellijXoffset == nil then
		m.zellijXoffset = -2
	end
	if m.zellijYoffset == nil then
		m.zellijYoffset = 2
	end
end

return m
