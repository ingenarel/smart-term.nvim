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
		col = math.floor((vim.o.columns - floatingWinWidth - 2) / 2),
		row = math.floor((vim.o.lines - floatingWinHeight - 2) / 2),
		border = "rounded",
		style = "minimal",
	})
	vim.cmd.term(command)
end

function m.openTmuxTerm(command)
	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * m.heightPercentage)
	vim.system({
		"tmux",
		"display-popup",
		"-E",
		"-w",
		tostring(floatingWinWidth),
		"-h",
		tostring(floatingWinHeight),
		"-d",
		vim.fn.getcwd(),
		command,
	})
end

function m.setup(opts)
	m.heightPercentage = opts.heightPercentage
	m.widthPercentage = opts.widthPercentage

	if m.heightPercentage == nil then
		m.heightPercentage = 70
	end
	if m.widthPercentage == nil then
		m.widthPercentage = 80
	end
end

return m
