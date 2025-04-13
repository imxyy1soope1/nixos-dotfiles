M = {
  hooks = {
    open = function ()
      require("core.globals").close_empty_buffer()
      vim.cmd("enew")
      vim.cmd("bufdo bd")
      require("sessions").load(nil, { silent = true })
      vim.cmd("NvimTreeFocus")
    end
  },
}

return M

