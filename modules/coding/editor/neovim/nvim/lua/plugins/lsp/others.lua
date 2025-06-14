-- Keymaps
local opt = require("core.globals").keymap_opt

vim.keymap.set("n", "K", vim.lsp.buf.hover, opt)
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, opt)

local icons = {}
local sev = vim.diagnostic.severity
local signs = {
  [sev.ERROR] = " ",
  [sev.WARN] = " ",
  [sev.HINT] = " ",
  [sev.INFO] = " ",
}
for type, icon in pairs(icons) do
  local hl = vim.diagnostic.severity[type]
  signs[hl] = icon
end
vim.diagnostic.config({
  signs = {
    text = signs,
  },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

local diag_config1 = {
  virtual_text = {
    severity = {
      max = vim.diagnostic.severity.WARN,
    },
    spacing = 4,
    prefix = "●",
  },
  virtual_lines = {
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
  },
}
local diag_config2 = {
  virtual_text = { spacing = 4, prefix = "●" },
  virtual_lines = false,
}
vim.diagnostic.config(diag_config1)
local diag_config_basic = false
vim.keymap.set("n", "<leader>ll", function()
  diag_config_basic = not diag_config_basic
  if diag_config_basic then
    vim.diagnostic.config(diag_config2)
  else
    vim.diagnostic.config(diag_config1)
  end
end, { desc = "Toggle diagnostic virtual_lines" })
