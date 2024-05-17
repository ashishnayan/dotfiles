require('lazy').setup({
  --
  -- 'ggandor/lightspeed.nvim',
  -- 'puremourning/vimspector',
  -- 'mhinz/vim-startify',
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',

  -- oil.nvim
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',    opts = {} },
  { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    -- opts = {
    -- -- Change code style ---
    -- -- Options are italic, bold, underline, none
    -- -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
    --   style = 'light',
    --   transparent = true,
    --   code_style = {
    --     comments = 'italic',
    --     keywords = 'italic',
    --     functions = 'italic',
    --     strings = 'none',
    --     variables = 'none'
    --   },
    -- },
  },
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup({})
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },
  {
    "rebelot/kanagawa.nvim", priority = 1000,
  },
  { "catppuccin/nvim",               name = "catppuccin", priority = 1000 },
  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {},
        tag = 'legacy',
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  {
    'L3MON4D3/LuaSnip',
    version = "v2.*",
    build = "make install_jsregexp",
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    lazy = false,
    priority = 100,
    dependencies = {
      "onsails/lspkind.nvim",
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      'saadparwaiz1/cmp_luasnip'
    },
  },
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}
  },
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*',       dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    'piersolenski/telescope-import.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    config = function()
      require("telescope").load_extension("import")
    end
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },
  { -- Nvim Tree
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require 'nvim-tree'.setup {} end

  },
  {
    "olexsmir/gopher.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    }
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup({})
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons'      -- optional
    },
  },
  -- { "SmiteshP/nvim-navic",       dependencies = { "neovim/nvim-lspconfig" }, },
  { -- nvim - harpoon
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function() require('telescope').load_extension('harpoon') end

  },
  -- Debugger DAP
  {
    'mfussenegger/nvim-dap',
    config = function()
      require('dap.ext.vscode').load_launchjs("launch.json", {})
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require('dapui').setup()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },

      })
    end,
  },
  { -- dap for python
    'mfussenegger/nvim-dap-python',
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function() require('dap-python').setup('/Users/ashishnayan/.pyenv/versions/py3.11nvim/bin/python') end
  },
  { 'vimwiki/vimwiki' },
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  {
    -- nvim - flash
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  }
}, {})
