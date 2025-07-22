vim.g.mapleader = " "

local keymap = vim.keymap
local globals = require("core.globals")
local opt = globals.keymap_opt
local buf_kill = globals.buf_kill

keymap.set("v", "<S-pageup>", ":m '<-2<CR>gv=gv", opt)
keymap.set("v", "<S-pagedown>", ":m '>+1<CR>gv=gv", opt)

keymap.set("n", "<leader>nh", ":nohl<CR>", opt)

keymap.set("n", "<leader>sv", "<C-w>v", opt)
keymap.set("n", "<leader>sh", "<C-w>s", opt)

keymap.set("v", ".", ">gv", opt)
keymap.set("v", ",", "<gv", opt)

keymap.set({ "n", "v" }, "<pageup>", "9k", opt)
keymap.set({ "n", "v" }, "<pagedown>", "9j", opt)
keymap.set("i", "<pageup>", string.rep("<up>", 9), opt)
keymap.set("i", "<pagedown>", string.rep("<down>", 9), opt)

keymap.set("n", "<leader>ww", ":w<CR>", opt)
keymap.set("n", "<leader>so", ":so<CR>", opt)
keymap.set("n", "<leader>qq", ":q<CR>", opt)
keymap.set("n", "<leader>qa", ":qa<CR>", opt)
keymap.set("n", "<leader>c", function()
  buf_kill("bd", nil, false)
end, opt)

keymap.set("n", "<C-up>", ":resize +5<CR>", opt)
keymap.set("n", "<C-down>", ":resize -5<CR>", opt)
keymap.set("n", "<C-right>", ":vert resize +5<CR>", opt)
keymap.set("n", "<C-left>", ":vert resize -5<CR>", opt)

-- buffer
keymap.set("n", "H", ":BufferLineCyclePrev<CR>", opt)
keymap.set("n", "L", ":BufferLineCycleNext<CR>", opt)
keymap.set("n", "<A-h>", ":BufferLineMovePrev<CR>", opt)
keymap.set("n", "<A-l>", ":BufferLineMoveNext<CR>", opt)

-- Neovide config
if vim.g.neovide then
  keymap.set("v", "<C-C>", '"+y', opt)
  keymap.set("n", "<C-V>", '"+P', opt)
  keymap.set("i", "<C-V>", '<ESC>l"+Pli', opt)
  keymap.set("c", "<C-V>", "<C-R>+", opt)
end
