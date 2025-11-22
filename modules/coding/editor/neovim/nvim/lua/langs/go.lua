vim.api.nvim_create_augroup("Go", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  desc = "auto format Go files",
  callback = function()
    vim.lsp.buf.format()
  end,
  group = "Go",
})
