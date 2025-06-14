M = {}

local tmuxnav = require("nvim-tmux-navigation")
local keymap = vim.keymap

keymap.set("n", "<C-H>", tmuxnav.NvimTmuxNavigateLeft)
keymap.set("n", "<C-J>", tmuxnav.NvimTmuxNavigateDown)
keymap.set("n", "<C-K>", tmuxnav.NvimTmuxNavigateUp)
keymap.set("n", "<C-L>", tmuxnav.NvimTmuxNavigateRight)
keymap.set("n", "<C-\\>", tmuxnav.NvimTmuxNavigateLastActive)
keymap.set("n", "<C-Space>", tmuxnav.NvimTmuxNavigateNext)

return M
