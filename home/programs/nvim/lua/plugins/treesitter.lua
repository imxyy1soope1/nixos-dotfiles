M = {
    auto_install = true,
    ensure_installed = {
        "vimdoc",
        "vim",
        "bash",
        "c",
        "cpp",
        "java",
        "javascript",
        "json",
        "lua",
        "python",
        "go",
        "rust",
        "markdown"
    },
    parser_install_dir = "$HOME/.local/share/treesitter",
    sync_install = true,
    modules = {},
    ignore_install = {},

    highlight = { enable = true },
    indent = { enable = true }
}

vim.opt.runtimepath:append("$HOME/.local/share/treesitter")

return M

