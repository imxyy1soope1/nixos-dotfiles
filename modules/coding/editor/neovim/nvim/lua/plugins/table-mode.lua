M = {}

vim.g.table_mode_corner = "|"

vim.api.nvim_create_augroup("TableModeAuto", {})

vim.api.nvim_create_user_command("TableModeAutoEnable", function()
  vim.api.nvim_clear_autocmds({ group = "TableModeAuto" })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = "TableModeAuto",
    pattern = { "*.md" },
    desc = "Auto enable TableMode",
    callback = function()
      vim.cmd("TableModeEnable")
    end,
  })
  vim.api.nvim_create_autocmd("BufWrite", {
    group = "TableModeAuto",
    pattern = { "*.md" },
    desc = "Auto enable TableMode",
    callback = function()
      vim.cmd("TableModeRealign")
    end,
  })
end, { desc = "Auto enable TableMode" })

vim.api.nvim_create_user_command("TableModeAutoDisable",
  function()
    vim.api.nvim_clear_autocmds({ group = "TableModeAuto" })
  end, {}
)

return M

