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
          expr = [[
            let
              lock = builtins.fromJSON (builtins.readFile ./flake.lock);
              nodeName = lock.nodes.root.inputs.nixpkgs;
            in
            import (fetchTarball {
              url = lock.nodes.${nodeName}.locked.url or "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.${nodeName}.locked.rev}.tar.gz";
              sha256 = lock.nodes.${nodeName}.locked.narHash;
            }) { }
          ]],
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
  -- keep-sorted start
  clangd = {},
  cssls = {},
  gopls = {},
  html = {},
  java_language_server = {},
  jsonls = {},
  pyright = {},
  ts_ls = {},
  typos_lsp = {},
  -- keep-sorted end
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
