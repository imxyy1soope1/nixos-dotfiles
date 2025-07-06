local servers = {
  "lua_ls",
  "pyright",
  "gopls",
  "clangd",
  "rust_analyzer",
  "ts_ls",
  "jsonls",
  "cssls",
  "nixd",
  "html",
}

local extra_config = {
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
      rust_analyzer = {
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
        nixpkgs = {
          expr = "import <nixpkgs> { }",
        },
        options = {
          nixos = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.imxyy-nix.options',
          },
        },
      },
    },
  },
  qmlls = {
    cmd = {"qmlls", "-E"}
  }
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
local lspconfig = require("lspconfig")
for _, server in ipairs(servers) do
  local extra = extra_config[server] or {}
  local config = {
    capabilities = capabilities,
  }
  for k, v in pairs(extra) do
    config[k] = v
  end
  lspconfig[server].setup(config)
end
