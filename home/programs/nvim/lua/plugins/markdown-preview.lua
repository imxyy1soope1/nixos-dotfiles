M = {}

vim.api.nvim_create_augroup("MarkdownPreviewAuto", {})

vim.api.nvim_create_user_command("MarkdownPreviewAutoEnable", function()
  vim.api.nvim_create_autocmd("BufEnter", {
    group = "MarkdownPreviewAuto",
    pattern = { "*.md" },
    desc = "Auto enable MarkdownPreview",
    callback = function()
      vim.cmd("MarkdownPreview")
    end,
  })
  vim.api.nvim_create_autocmd("BufLeave", {
    group = "MarkdownPreviewAuto",
    pattern = { "*.md" },
    desc = "Auto disable MarkdownPreview",
    callback = function()
      vim.cmd("MarkdownPreviewStop")
    end,
  })
end, { desc = "Auto enable MarkdownPreview" })

vim.api.nvim_create_user_command("MarkdownPreviewAutoDisable",
  function()
    vim.api.nvim_clear_autocmds({ group = "MarkdownPreviewAuto" })
  end, {}
)

return M

