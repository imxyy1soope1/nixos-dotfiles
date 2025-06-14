vim.api.nvim_create_augroup("Go", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  desc = "auto format Go files",
  callback = function()
    vim.lsp.buf.format()
    -- vim.fn.system("go fmt " .. vim.fn.expand("%:p"))
    -- vim.fn.system("goimports -w " .. vim.fn.expand("%:p"))
    -- vim.cmd("edit")
  end,
  group = "Go",
})
