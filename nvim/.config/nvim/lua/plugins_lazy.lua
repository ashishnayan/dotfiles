require('lazy').setup({
  --
  -- 'ggandor/lightspeed.nvim',
  -- 'puremourning/vimspector',
  -- 'mhinz/vim-startify',
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',

  -- which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- oil.nvim
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- vim code folding
  -- {
  --   'kevinhwang91/nvim-ufo',
  --   dependencies = 'kevinhwang91/promise-async',
  --   config = function()
  --     require 'ufo'.setup({
  --       provider_selector = function(bufnr, filetype, buftype)
  --         return { 'lsp', 'indent' }
  --       end,
  --     })
  --   end
  -- },
  -- "gc" to comment visual regions/lines
  -- { 'numToStr/Comment.nvim',    opts = {} },
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
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     -- add any options here
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --   }
  -- },
  -- {
  --   'glepnir/dashboard-nvim',
  --   event = 'VimEnter',
  --   dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  -- },
  {
    "rebelot/kanagawa.nvim", priority = 1000,
  },
  { "catppuccin/nvim",          name = "catppuccin",                   priority = 1000 },
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
      'saghen/blink.cmp',

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
  -- { 'jose-elias-alvarez/null-ls.nvim' },
  -- { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
  -- {
  --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   config = function()
  --     require("lsp_lines").setup()
  --   end,
  -- },
  {
    'L3MON4D3/LuaSnip',
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  -- { -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   lazy = false,
  --   priority = 100,
  --   dependencies = {
  --     "onsails/lspkind.nvim",
  --     'hrsh7th/cmp-nvim-lsp',
  --     'L3MON4D3/LuaSnip',
  --     "hrsh7th/cmp-path",
  --     "hrsh7th/cmp-buffer",
  --     'saadparwaiz1/cmp_luasnip'
  --   },
  -- },
  --  Autocomplete blink.cmp
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = 'default' },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        -- optionally disable cmdline completions
        -- cmdline = {},
      },

      -- experimental signature help support
      signature = { enabled = true }
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" }
  },
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
  },
  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}
  },
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

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
    branch = "harpoon2",
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    -- config = function() require('telescope').load_extension('harpoon') end
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
  { 'echasnovski/mini.icons',        version = '*' },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      notifier = {
        enabled = true,
        style = "compact",
        timeout = 2500,
      },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
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
  },
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-completion",
  "kristijanhusak/vim-dadbod-ui",
  "github/copilot.vim",
}, {})
