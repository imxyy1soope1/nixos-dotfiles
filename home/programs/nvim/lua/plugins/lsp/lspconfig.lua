local servers = {
  "lua_ls",
  "pyright",
  "gopls",
  "clangd",
  "rust_analyzer",
  "tsserver",
  "jsonls",
  "cssls",
  "nil_ls",
  -- "nixd",
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
          }
        },
        diagnostics = {
          globals = {
            "vim"
          }
        },
        completion = {
          callSnippet = "Replace"
        }
      }
    },
  },
  rust_analyzer = {
    settings = {
      rust_analyzer = {
        check = {
          command = "clippy"
        },
        formatting = {
          command = { "rustfmt" },
        },
      }
    },
  },
  --[[ nixd = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = "import <nixpkgs> { }",
        },
        formatting = {
          command = { "nixpkgs-fmt" },
        },
        options = {
          nixos = {
            expr = '(builtins.getFlake ".").nixosConfigurations."imxyy-nix".options',
          },
        },
      },
    },
  } ]]
}

local on_attach = function(client, bufnr)
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "line",
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
end
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
    on_attach = on_attach,
    capabilities = capabilities
  }
  for k, v in pairs(extra) do
    config[k] = v
  end
  lspconfig[server].setup(config)
end

