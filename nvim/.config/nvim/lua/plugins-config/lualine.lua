-- local navic = require("nvim-navic")
require 'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic', 'coc' } } },
    lualine_c = { { 'filename', file_status = true, path = 1 } },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress', 'searchcount' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  -- tabline = {
  --   lualine_a = {'buffers'},
  --   lualine_b = {},
  --   lualine_c = {},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = {'tabs'}
  -- },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        function()
          return require('lspsaga.symbol.winbar').get_bar()
        end,
      },
      --      {
      --      function()
      --      return navic.get_location()
      --  end,
      --cond = function()
      -- return navic.is_available()
      --end
      --},
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {}
}
