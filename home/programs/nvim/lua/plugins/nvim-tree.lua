M = {
  sync_root_with_cwd = true,
  diagnostics = {
    enable = false,
    debounce_delay = 50,
    show_on_dirs = true
  },
  filters = {
    git_ignored = false
  }
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = require("core.globals").keymap_opt
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opt)
vim.keymap.set("n", "<leader>te", ":NvimTreeFocus<CR>", opt)

return M

