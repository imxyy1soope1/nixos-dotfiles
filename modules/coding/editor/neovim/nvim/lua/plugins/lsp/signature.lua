M = {
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded",
  },
  hint_prefix = "^ ",
  toggle_key = "<C-k>",
}

vim.keymap.set(
  { "n" },
  "<leader>k",
  require("lsp_signature").toggle_float_win,
  { silent = true, noremap = true, desc = "toggle signature" }
)

vim.keymap.set({ "n" }, "K", vim.lsp.buf.signature_help, { silent = true, noremap = true, desc = "toggle signature" })

return M
