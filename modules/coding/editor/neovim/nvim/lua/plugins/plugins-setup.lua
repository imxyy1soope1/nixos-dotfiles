local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/lua/"

local plugins = {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
    config = function()
      require("lualine").setup(require("plugins.lualine"))
    end,
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "\\", ":Neotree reveal toggle<CR>", desc = "Toggle NeoTree", silent = true },
      { "<leader>e", ":Neotree reveal toggle<CR>", desc = "Toggle NeoTree", silent = true },
    },
    --- @type neotree.Config
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
        window = {
          width = 30,
          mappings = {
            ["\\"] = "close_window",
            ["<leader>e"] = "close_window",
            ["<c-]>"] = "set_root",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      {
        branch = "main",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    config = function()
      require("nvim-treesitter").setup(require("plugins.treesitter"))
    end,
    build = ":TSUpdate",
  },
  {
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("plugins.rainbow-delimiters")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = { "https://gitlab.com/HiPhish/rainbow-delimiters.nvim" },
    config = function()
      require("ibl").setup(require("plugins.indent-blankline"))
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    opt = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      require("plugins.lsp.lspconfig")
      require("plugins.lsp.others")
    end,
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
    opts = {},
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = {
      "neovim/nvim-lspconfig",
      "onsails/lspkind.nvim",
    },
    opts = {},
  },
  {
    "hedyhli/outline.nvim",
    event = "LspAttach",
    config = function()
      require("outline").setup(require("plugins.lsp.outline"))
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = { { "rafamadriz/friendly-snippets", lazy = true } },
        build = "make install_jsregexp",
        config = function()
          require("luasnip").setup(require("plugins.cmp.luasnip"))
        end,
      },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "saghen/blink.lib",
    },
    config = function()
      require("blink.cmp").setup(require("plugins.cmp.cmp"))
    end,
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup(require("plugins.bufferline"))
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup(require("plugins.gitsigns"))
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
    config = function()
      require("telescope").setup(require("plugins.telescope"))
    end,
  },
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      {
        "<leader>lr",
        "<cmd>Glance references<cr>",
      },
      {
        "<leader>ld",
        "<cmd>Glance definitions<cr>",
      },
      {
        "<leader>lD",
        "<cmd>Glance type_definitions<cr>",
      },
      {
        "<leader>li",
        "<cmd>Glance implementations<cr>",
      },
    },
  },
  {
    "https://codeberg.org/andyg/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set({ "n", "x", "o" }, "<leader>s", "<Plug>(leap)")
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
      -- Exclude whitespace and the middle of alphabetic words from preview:
      --   foobar[baaz] = quux
      --   ^----^^^--^^-^-^--^
      require("leap").opts.preview_filter = function(ch0, ch1, ch2)
        return not (ch1:match("%s") or ch0:match("%a") and ch1:match("%a") and ch2:match("%a"))
      end
      require("leap.user").set_repeat_keys("<enter>", "<backspace>")
    end,
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup(require("plugins.tmuxnav"))
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    event = "BufEnter *.md",
    --- @type render.md.UserConfig
    opts = {
      completions = {
        blink = {
          enabled = true,
        },
        lsp = {
          enabled = true,
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
  },
  {
    "voldikss/vim-floaterm",
    config = function()
      require("plugins.floaterm")
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = {},
  },
  {
    "pest-parser/pest.vim",
    ft = "pest",
    opts = {},
  },

  {
    "nmac427/guess-indent.nvim",
    opts = {},
  },

  {
    "https://codeberg.org/fosk/registers.nvim",
    cmd = "Registers",
    config = true,
    keys = {
      { '"', mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
    name = "registers",
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    enabled = false,
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "dynamic",
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
        },
      },
    },
  },
}

require("lazy").setup(plugins, {})
