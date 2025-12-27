vim.lsp.config("nixd", {
  settings = {
    nixd = {
      options = {
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.'
            .. vim.uv.os_gethostname()
            .. ".options",
        },
      },
      diagnostic = {
        suppress = {
          "sema-primop-overridden",
        },
      },
    },
  },
})

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0,
      })
    end,
  },
}
