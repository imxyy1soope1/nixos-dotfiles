M = {
  auto_install = true,
  parser_install_dir = "$HOME/.local/share/nvim/lazy/nvim-treesitter",
  sync_install = true,
  modules = {},
  ignore_install = {},

  highlight = { enable = true },
  indent = { enable = true },
}

vim.filetype.add({
  pattern = {
    [".*/hypr/.*%.conf"] = "hyprlang",
    [".*%.hl"] = "hyprlang",
  },
})

return M
