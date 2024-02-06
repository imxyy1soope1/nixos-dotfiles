M = {}

-- thx to seblj [https://github.com/seblj/dotfiles/blob/0542cae6cd9a2a8cbddbb733f4f65155e6d20edf/nvim/lua/config/lspconfig/signature.lua]
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local util = require('vim.lsp.util')
local handler
local clients = {}

local check_trigger_char = function(line_to_cursor, triggers)
    if not triggers then
        return false
    end

    for _, trigger_char in ipairs(triggers) do
        local current_char = line_to_cursor:sub(#line_to_cursor, #line_to_cursor)
        local prev_char = line_to_cursor:sub(#line_to_cursor - 1, #line_to_cursor - 1)
        if current_char == trigger_char then
            return true
        end
        if current_char == ' ' and prev_char == trigger_char then
            return true
        end
    end
    return false
end

local open_signature = function()
    local triggered = false

    for _, client in pairs(clients) do
        local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

        -- csharp has wrong trigger chars for some odd reason
        if client.name == 'csharp' then
            triggers = { '(', ',' }
        end

        local pos = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local line_to_cursor = line:sub(1, pos[2])

        if not triggered then
            triggered = check_trigger_char(line_to_cursor, triggers)
        end
    end

    if triggered then
        local params = util.make_position_params()
        vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, handler)
    end
end

local signature_setup = function(client)
    handler = vim.lsp.with(vim.lsp.handlers.signature_help, {
        silent = true,
        focusable = false,
    })

    table.insert(clients, client)

    local group = augroup('LspSignature', { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, pattern = '<buffer>' })
    autocmd('TextChangedI', {
        group = group,
        pattern = '<buffer>',
        callback = function()
            -- Guard against spamming of method not supported after
            -- stopping a language serer with LspStop
            local active_clients = vim.lsp.get_active_clients()
            if #active_clients < 1 then
                return
            end
            open_signature()
        end,
    })
end

function M.on_attach(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    if client.server_capabilities.signatureHelpProvider then
        signature_setup(client)
    end

    if not  client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

return M

