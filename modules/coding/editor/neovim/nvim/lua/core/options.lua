local opt = vim.opt

-- Tab width setting
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true

-- Linenumber setting
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.cursorline = true

opt.mouse:append("a")
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "110"
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 500
opt.timeoutlen = 500

opt.completeopt = ""

opt.autoread = true
vim.g.autoread = true

vim.g.loaded_ruby_provider = 0

-- Hightlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Remember last position
vim.cmd([[
   autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif 
]])

-- Automaticly switch input method
Last_input_method = 1
vim.api.nvim_create_augroup("AutoInputMethod", {})
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  desc = "Automaticly switch input method",
  callback = function()
    Last_input_method = require("core.globals").switch_input_method(1)
  end,
  group = "AutoInputMethod",
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  desc = "Automaticly switch input method",
  callback = function()
    require("core.globals").switch_input_method(1)
  end,
  group = "AutoInputMethod",
})
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  desc = "Automaticly switch input method",
  callback = function()
    require("core.globals").switch_input_method(Last_input_method)
  end,
  group = "AutoInputMethod",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  desc = "fix gf functionality inside .lua files",
  callback = function()
    ---@diagnostic disable: assign-type-mismatch
    -- credit: https://github.com/sam4llis/nvim-lua-gf
    vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
    vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
    vim.opt_local.suffixesadd:prepend(".lua")
    vim.opt_local.suffixesadd:prepend("init.lua")

    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
      vim.opt_local.path:append(path .. "/lua")
    end
  end,
})

-- MkDir
vim.api.nvim_create_user_command("MakeDirectory", function()
  ---@diagnostic disable-next-line: missing-parameter
  local path = vim.fn.expand("%")
  local dir = vim.fn.fnamemodify(path, ":p:h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  else
    vim.notify("Directory already exists", vim.log.levels.WARN, { title = "Nvim" })
  end
end, { desc = "Create directory if it doesn't exist" })
