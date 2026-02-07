local buf_kill = require("core.globals").buf_kill

--- @type bufferline.UserConfig
M = {
  highlights = {
    buffer_selected = {
      bold = true,
    },
  },
  options = {
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "center",
      },
    },
    close_command = function(bufnr)
      buf_kill("bd", bufnr, false)
    end,
    right_mouse_command = function(bufnr)
      buf_kill("bd", bufnr, true)
    end,
  },
}

vim.opt.termguicolors = true

return M
