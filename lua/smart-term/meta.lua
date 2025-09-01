-- vim:set textwidth=81:
---@meta

---@class smartTerm
local smartTerm = {}

---@class smartTerm.nvim
smartTerm.nvim = {}
function smartTerm.nvim.float(opts) end
function smartTerm.nvim.split(opts) end

---@class smartTerm.tmux
smartTerm.tmux = {}
function smartTerm.tmux.float(opts) end
function smartTerm.tmux.split(opts) end

---@class smartTerm.zellij
smartTerm.zellij = {}
function smartTerm.zellij.float(opts) end
function smartTerm.zellij.split(opts) end

---@class smartTerm.init
---@field shared smartTerm.init.shared
smartTerm.init = {}
function smartTerm.init.open(opts) end
function smartTerm.init.setup(opts) end

---@class smartTerm.init.shared
---@field floatHeightPercentage number
---@field floatWidthPercentage number
---@field splitHeightPercentage number
---@field splitWidthPercentage number
---@field floatNeovimXoffset number
---@field floatNeovimYoffset number
---@field floatTmuxXoffset number
---@field floatTmuxYoffset number
---@field floatZellijXoffset number
---@field floatZellijYoffset number
