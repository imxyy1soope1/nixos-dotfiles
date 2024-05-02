vim.api.nvim_create_augroup("Nix", {})

local old = {}
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.nix" },
  desc = "auto nix file indent",
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
  group = "Nix",
})
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = { "*.nix" },
  desc = "auto nix file indent",
  callback = function()
    local opt = vim.opt
    -- Tab width setting
    opt.tabstop = old.tabstop
    opt.shiftwidth = old.shiftwidth
    opt.softtabstop = old.softtabstop
    opt.expandtab = old.expandtab
  end,
  group = "Nix",
})

