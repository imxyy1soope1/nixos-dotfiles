--- @module "blink.cmp"
--- @type blink.cmp.Config
M = {
  keymap = {
    -- <Tab> to accept
    preset = "super-tab",
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = true, auto_show_delay_ms = 1000 },
  },
  sources = {
    default = { "lsp", "path", "snippets", "lazydev" },
    providers = {
      lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },
  snippets = { preset = "luasnip" },

  -- See :h blink-cmp-config-fuzzy for more information
  fuzzy = {
    implementation = "lua",
  },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}

return M
