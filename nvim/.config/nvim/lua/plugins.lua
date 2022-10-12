return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use 'wbthomason/packer.nvim'
  
  -- Color scheme
  use { 'sainnhe/gruvbox-material' }
  use { 'navarasu/onedark.nvim' }
  use { 'Mofiqul/vscode.nvim' }
  use { 'tiagovla/tokyodark.nvim' }
  use { 'mhartington/oceanic-next' }
  use { 'EdenEast/nightfox.nvim' }
  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- LuaLine
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  -- Airline
  -- use 'vim-airline/vim-airline'
  -- use 'vim-airline/vim-airline-themes'


  -- LSP and Autocomplete
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'williamboman/nvim-lsp-installer'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  -- Lua Snippets
  use 'saadparwaiz1/cmp_luasnip'
  use { 
    'L3MON4D3/LuaSnip',
  }
  use 'onsails/lspkind-nvim'

  -- LspSaga
  -- use 'glepnir/lspsaga.nvim'

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
      disable = { "ruby" }
    },
    autotag = {
      enable = true,
    }
  }

  -- FloatTerm
  use 'voldikss/vim-floaterm'

  -- Fugitive for Git
--  use { 'tpope/vim-fugitive' }
  
  -- Gitsigns
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    -- tag = 'release' -- To use the latest release
    -- config = function()
      -- require('gitsigns').setup()
    -- end
  }

  -- Nvim-Tree
  use {
    'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icon
      },
      config = function() require'nvim-tree'.setup {} end
  }

  -- indent-blankline
  use { 
    "lukas-reineke/indent-blankline.nvim",
    config = function() require'indent_blankline'.setup {
        show_current_context = false,
        show_current_context_start = false,
        space_char_blankline = " ",
     }
    end
  }

  --  nvim-lint
  --  use { 'mfussenegger/nvim-lint' }


  -- VimWiki
  use { 'vimwiki/vimwiki' }

  -- Lightspeed
  use 'ggandor/lightspeed.nvim'

  -- Debugging
  use { 'puremourning/vimspector' }

  -- Maximizer
  use { 'szw/vim-maximizer' }

  -- Startify
  use { 'mhinz/vim-startify' }

  -- Comment
  use { 'numToStr/Comment.nvim' }
  -- Todo Comment
  use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" }

  -- Bufferline 
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}

  -- Auto-pair bracket
  use {'windwp/nvim-autopairs'}
  use {'windwp/nvim-ts-autotag'}
end)
