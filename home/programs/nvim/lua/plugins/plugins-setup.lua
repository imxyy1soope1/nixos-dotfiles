local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/lua/"

local plugins = {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function ()
            vim.cmd.colorscheme("tokyonight-storm")
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
        config = function()
            require("lualine").setup(require("plugins.lualine"))
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
        config = function()
            require("nvim-tree").setup(require("plugins.nvim-tree"))
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            require("nvim-treesitter.configs").setup(require("plugins.treesitter"))
        end
    },
    {
        url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        lazy = false,
        event = "VeryLazy",
        config = function()
            require("plugins.rainbow-delimiters")
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        lazy = false,
        event = "VeryLazy",
        config = function()
            require("ibl").setup(require("plugins.indent-blankline"))
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        lazy = false,
        config = function()
            require("plugins.lsp.lspconfig")
            require("plugins.lsp.others")
        end
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        config = function()
            require("lsp_signature").setup(require("plugins.lsp.signature"))
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        config = function ()
            require("plugins.lsp.trouble")
        end
    },
    {
        "folke/neodev.nvim",
        lazy = true,
        event = "BufEnter *.lua",
        config = function()
            require("neodev").setup(require("plugins.neodev"))
        end
    },
    {
        "L3MON4D3/LuaSnip",
        lazy = false,
        dependencies = { { "rafamadriz/friendly-snippets", lazy = true } },
        config = function ()
            require("luasnip").setup(require("plugins.cmp.luasnip"))
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim"
        },
        lazy = false,
        config = function ()
            require("cmp").setup(require("plugins.cmp.cmp"))
        end
    },
    {
        "j-hui/fidget.nvim",
        lazy = true,
        tag = "legacy",
        event = "LspAttach",
        config = function ()
            require("fidget").setup(require("plugins.lsp.fidget"))
        end
    },
    {
        "numToStr/Comment.nvim",
        lazy = false,
        event = "VeryLazy",
        config = function ()
            require("Comment").setup(require("plugins.comment"))
        end
    },
    {
        "windwp/nvim-autopairs",
        lazy = false,
        event = "VeryLazy",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function ()
            require("nvim-autopairs").setup(require("plugins.autopairs"))
        end
    },
    --[[ {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        lazy = false,
        event = "VeryLazy"
    }, ]]
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        config = function ()
            require("bufferline").setup(require("plugins.bufferline"))
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        event = "VeryLazy",
        config = function ()
            require("gitsigns").setup(require("plugins.gitsigns"))
        end
    },
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.2",
        dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
        config = function ()
            require("telescope").setup(require("plugins.telescope"))
        end
    },
    {
        "alexghergh/nvim-tmux-navigation",
        lazy = false,
        event = "VeryLazy",
        config = function ()
            require("nvim-tmux-navigation").setup(require("plugins.tmuxnav"))
        end
    },
    {
        "natecraddock/sessions.nvim",
        lazy = false,
        event = "VeryLazy",
        config = function ()
            require("sessions").setup(require("plugins.sessions"))
        end
    },
    {
        "natecraddock/workspaces.nvim",
        lazy = false,
        event = "VeryLazy",
        depedencies = { "nvim-telescope/telescope.nvim", "natecraddock/sessions.nvim" },
        config = function ()
            require("workspaces").setup(require("plugins.workspaces"))
            require("telescope").load_extension("workspaces")
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        lazy = true,
        event = "BufEnter *.md",
        build = function ()
            vim.fn["mkdp#util#install"]()
        end,
        config = function ()
            require("plugins.markdown-preview")
        end
    },
    {
        "dhruvasagar/vim-table-mode",
        lazy = true,
        event = "BufEnter *.md",
        config = function ()
            require("plugins.table-mode")
        end
    },
    {
        "rcarriga/nvim-notify",
        lazy = false,
        event = "VeryLazy",
        config = function ()
            require("plugins.notify")
        end
    },
    {
        "luckasRanarison/tree-sitter-hypr",
        depedencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = false,
        event = "VeryLazy",
        config = function ()
            require("plugins.treesitter-hypr")
        end
    },
    {
        "voldikss/vim-floaterm",
        lazy = false,
        event = "VeryLazy",
        config = function ()
            require("plugins.floaterm")
        end
    }
}

local opts = {}

require("lazy").setup(plugins, opts)

