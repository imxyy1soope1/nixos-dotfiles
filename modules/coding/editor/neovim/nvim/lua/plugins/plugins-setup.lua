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
    config = function()
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nushell/tree-sitter-nu"
    },
    config = function()
      require("nvim-treesitter.configs").setup(require("plugins.treesitter"))
    end,
    build = ":TSUpdate"
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
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {}
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end
  },
  {
    "hedyhli/outline.nvim",
    event = "LspAttach",
    config = function()
      require("outline").setup(require("plugins.lsp.outline"))
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    dependencies = { { "rafamadriz/friendly-snippets", lazy = true } },
    build = "make install_jsregexp",
    config = function()
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
    config = function()
      require("cmp").setup(require("plugins.cmp.cmp"))
    end
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
    event = "VeryLazy",
    config = function()
      require("Comment").setup(require("plugins.comment"))
    end
  },
  {
    "windwp/nvim-autopairs",
    lazy = false,
    event = "VeryLazy",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup(require("plugins.autopairs"))
    end
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    config = function()
      require("bufferline").setup(require("plugins.bufferline"))
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup(require("plugins.gitsigns"))
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
    config = function()
      require("telescope").setup(require("plugins.telescope"))
    end
  },
  {
    "alexghergh/nvim-tmux-navigation",
    lazy = false,
    event = "VeryLazy",
    config = function()
      require("nvim-tmux-navigation").setup(require("plugins.tmuxnav"))
    end
  },
  {
    "natecraddock/sessions.nvim",
    lazy = false,
    event = "VeryLazy",
    config = function()
      require("sessions").setup(require("plugins.sessions"))
    end
  },
  {
    "natecraddock/workspaces.nvim",
    lazy = false,
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim", "natecraddock/sessions.nvim" },
    config = function()
      require("workspaces").setup(require("plugins.workspaces"))
      require("telescope").load_extension("workspaces")
    end
  },
  --[[ {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewAutoEnable", "MarkdownPreviewAutoDisable" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      require("plugins.markdown-preview")
    end
  }, ]]
  --[[ {
    "dhruvasagar/vim-table-mode",
    lazy = true,
    event = "BufEnter *.md",
    config = function()
      require("plugins.table-mode")
    end
  }, ]]
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true, -- or `opts = {}`
  },
  {
    "folke/noice.nvim",
    lazy = false,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      }
    }
  },
  {
    "voldikss/vim-floaterm",
    lazy = false,
    event = "VeryLazy",
    config = function()
      require("plugins.floaterm")
    end
  },
  {
    "folke/todo-comments.nvim",
    lazy = false,
    event = "VeryLazy",
    opts = {},
  },
  {
    "ojroques/nvim-osc52",
    event = "BufEnter",
    config = function()
      require("osc52").setup({
        tmux_passthrough = true
      })
      local function copy()
        if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
          require("osc52").copy_register("+")
        end
      end
      vim.api.nvim_create_autocmd("TextYankPost", {callback = copy})
    end
  },
  {
    "pest-parser/pest.vim",
    event = "VeryLazy",
    opts = {}
  }
}

local opts = {
  rocks = {
    enabled = false
  }
}

require("lazy").setup(plugins, opts)
