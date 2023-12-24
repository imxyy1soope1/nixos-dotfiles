local autoconfig_excluded = {
    lua_ls = true
}

local ok, cmp = pcall(require, "cmp_nvim_lsp")
local capabilities = {}
if ok then
    capabilities = cmp.default_capabilities()
else
    capabilities = {}
end

local on_attach = require("plugins.lsp.signature").on_attach

local lspconfig = require("lspconfig")
for _, server in ipairs(require("plugins.lsp.servers")) do
    if autoconfig_excluded[server] ~= nil then
        goto continue
    end

    lspconfig[server].setup({
        capabilities = capabilities,
        on_attach = on_attach
    })
    ::continue::
end

-- Manually configure
lspconfig["lua_ls"].setup({
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
    capabilities = capabilities,
    on_attach = on_attach
})

