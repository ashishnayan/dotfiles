-- local nightfox = require('nightfox')
--
-- nightfox.setup({
--   -- fox = "nightfox", -- Which fox style should be applied
--   fox = "nordfox", -- Which fox style should be applied
--   transparent = false, -- Disable setting the background color
--   alt_nc = false, -- Non current window bg to alt color see `hl-NormalNC`
--   terminal_colors = true, -- Configure the colors used when opening :terminal
--   styles = {
--     comments = "italic", -- Style that is applied to comments: see `highlight-args` for options
--     functions = "italic", -- Style that is applied to functions: see `highlight-args` for options
--     keywords = "bold", -- Style that is applied to keywords: see `highlight-args` for options
--     strings = "NONE", -- Style that is applied to strings: see `highlight-args` for options
--     variables = "NONE", -- Style that is applied to variables: see `highlight-args` for options
--   },
--   inverse = {
--     match_paren = false, -- Enable/Disable inverse highlighting for match parens
--     visual = true, -- Enable/Disable inverse highlighting for visual selection
--     search = false, -- Enable/Disable inverse highlights for search highlights
--   },
--   colors = {}, -- Override default colors
--   hlgroups = {}, -- Override highlight groups
-- })
--
-- nightfox.load()

require('nightfox').setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false,               -- Disable setting background
    terminal_colors = true,            -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,              -- Non focused panes set to alternative background
    styles = {                         -- Style to be applied to different syntax groups
      comments = "italic",             -- Value is any valid attr-list value `:help attr-list`
      conditionals = "NONE",
      constants = "italic",
      functions = "italic",
      keywords = "bold",
      numbers = "NONE",
      operators = "bold",
      strings = "NONE",
      types = "italic,bold",
      variables = "NONE",
    },
    inverse = { -- Inverse highlight for different types
      match_paren = false,
      visual = true,
      search = true,
    },
    modules = { -- List of various plugins and additional options
      -- ...
    },
  }
})
vim.cmd("colorscheme nightfox")
