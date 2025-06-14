M = {
  defaults = {
    winblend = 50,
    path_display = {
      "smart",
      shorten = 3,
    },
  },
  pickers = {
    lsp_definitions = {
      theme = "cursor",
      layout_config = { width = 0.6, height = 0.3 },
    },
    lsp_references = {
      theme = "cursor",
      layout_config = { width = 0.6, height = 0.3 },
    },
    current_buffer_fuzzy_find = {
      theme = "dropdown",
      layout_config = { height = 0.7, width = 0.55, preview_cutoff = 0, prompt_position = "top" },
    },
    lsp_document_symbols = {
      theme = "ivy",
      layout_config = { height = 0.25 },
    },
  },
}

local opt = require("core.globals").keymap_opt
local keymap = vim.keymap
local builtin = require("telescope.builtin")

keymap.set("n", "<leader>ff", builtin.find_files, opt)
keymap.set("n", "<leader>gf", builtin.git_files, opt)
keymap.set("n", "<leader>fg", builtin.live_grep, opt)
keymap.set("n", "<leader>fb", builtin.buffers, opt)
keymap.set("n", "<leader>fh", builtin.help_tags, opt)
-- keymap.set('n', '<leader>lD', builtin.diagnostics, opt)
keymap.set("n", "<leader>ld", builtin.lsp_definitions, opt)
keymap.set("n", "<leader>lr", builtin.lsp_references, opt)
keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, opt)
keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, opt)

return M
