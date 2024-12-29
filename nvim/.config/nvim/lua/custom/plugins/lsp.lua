return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "folke/lazydev.nvim", ft = "lua", },
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      'saghen/blink.cmp',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {},
        tag = 'legacy',
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      -- 'folke/neodev.nvim',
    },
    config = function()
      require('custom.lsp')
    end,
  },
}
