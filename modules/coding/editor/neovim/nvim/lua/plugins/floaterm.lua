local keymap = vim.keymap
local opt = require("core.globals").keymap_opt

keymap.set("n", "<leader>tt", ":FloatermNew<CR>", opt)
