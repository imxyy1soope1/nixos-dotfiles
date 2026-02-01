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

return {}
