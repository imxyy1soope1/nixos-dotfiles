-- rainbow-delimiters integration
local hooks = require("ibl.hooks")
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

--- @type ibl.config
M = {
  enabled = true,
  indent = {
    tab_char = "▎",
  },
  scope = {
    enabled = true,
    show_start = false,
    highlight = vim.g.rainbow_delimiters.highlight,
  },
}

vim.opt.list = true

return M
