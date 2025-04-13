vim.api.nvim_create_augroup("Rust", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.rs" },
  desc = "auto format Rust files",
  callback = function()
    vim.fn.system("rustfmt " .. vim.fn.expand("%:p"))
    vim.cmd("edit")
  end,
  group = "Rust",
})

