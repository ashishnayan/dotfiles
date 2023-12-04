local db = require('dashboard')
db.setup({
  theme = 'hyper',
  config = {
    week_header = {
      enable = true,
      concat = "",
      append = {},
    },
    hide = {
      statusline = true, -- hide statusline default is true
      tabline = true,    -- hide the tabline
      winbar = true,     -- hide winbar
    },
    shortcut = {
      { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        desc = ' ColorScheme',
        group = 'DiagnosticHint',
        action = 'Telescope colorscheme',
        key = 'a',
      },
      {
        desc = ' Git-Status',
        group = 'Number',
        action = 'Telescope git_status',
        key = 'd',
      },
    },
  },
})
