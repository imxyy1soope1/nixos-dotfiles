M = {
  sync_root_with_cwd = true,
  diagnostics = {
    enable = false,
    debounce_delay = 50,
    show_on_dirs = true,
  },
  filters = {
    git_ignored = false,
  },
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = require("core.globals").keymap_opt
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opt)
vim.keymap.set("n", "<leader>te", ":NvimTreeFocus<CR>", opt)

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeCloseOnLast", { clear = true }),
  pattern = "NvimTree*",
  callback = function()
    if vim.api.nvim_call_function("winlayout", {})[1] == "leaf" and vim.bo.filetype == "NvimTree" then
      vim.defer_fn(function()
        vim.cmd("NvimTreeClose")
      end, 10)
    end
  end,
})

return M