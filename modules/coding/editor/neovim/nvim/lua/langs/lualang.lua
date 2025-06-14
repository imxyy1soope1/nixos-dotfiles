vim.api.nvim_create_augroup("Lua", {})

local old = {}
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.lua" },
  desc = "auto lua file indent",
  callback = function()
    local opt = vim.opt
    -- Tab width setting
    old.tabstop = opt.tabstop
    old.shiftwidth = opt.shiftwidth
    old.softtabstop = opt.softtabstop
    old.expandtab = opt.expandtab
    opt.tabstop = 2
    opt.shiftwidth = 2
    opt.softtabstop = 2
    opt.expandtab = true
    opt.autoindent = true
  end,
  group = "Lua",
})
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = { "*.lua" },
  desc = "auto lua file indent",
  callback = function()
    local opt = vim.opt
    -- Tab width setting
    opt.tabstop = old.tabstop
    opt.shiftwidth = old.shiftwidth
    opt.softtabstop = old.softtabstop
    opt.expandtab = old.expandtab
  end,
  group = "Lua",
})
