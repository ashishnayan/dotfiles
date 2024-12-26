return {
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('neogen').setup({
        enabled = true,
        languages = {
          lua = {
            template = {
              annotation_convention = "emmylua"
              -- for a full list of annotation_conventions, see supported-languages below,
              -- for more template configurations, see the language's configuration file in configurations/{lang}.lua
            }
          },
          python = {
            template = {
              annotation_convention = "reST"
            }
          },
        }
      })
      vim.keymap.set('n', '<M-d>', require 'neogen'.generate, { desc = 'Generate Docstring' })
      vim.keymap.set('n', '<M-n>', require 'neogen'.jump_next, { desc = 'Jump to Next Docstring' })
      vim.keymap.set('n', '<M-b>', require 'neogen'.jump_prev, { desc = 'Jump to Previous Docstring' })
    end,
  },
}
