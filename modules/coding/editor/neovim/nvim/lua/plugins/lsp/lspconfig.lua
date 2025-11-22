local servers = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          library = {
            vim.api.nvim_get_runtime_file("", true),
            "${3rd}/luv/library",
            "${3rd}/luassert/library",
          },
        },
        diagnostics = {
          globals = {
            "vim",
          },
        },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
        },
        diagnostics = {
          experimental = true,
        },
        formatting = {
          command = { "rustfmt" },
        },
      },
    },
  },
  nixd = {
    settings = {
      nixd = {
        formatting = {
          command = { "nixfmt" },
        },
        nixpkgs = {
          expr = "import <nixpkgs> { }",
        },
      },
    },
  },
  tinymist = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
  },
  qmlls = {
    cmd = { "qmlls", "-E" },
  },
  pyright = {},
  gopls = {},
  clangd = {},
  ts_ls = {},
  jsonls = {},
  cssls = {},
  html = {},
  java_language_server = {},
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
for server, config in pairs(servers) do
  config["capabilities"] = capabilities
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
