-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    -- layout_strategy = "center",
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
    },
    buffers = {
      theme = "dropdown",
    },
    lsp_references = {
      theme = "dropdown",
    },
  },
  extensions = {
    import = {
      -- Add imports to the top of the file keeping the cursor in place
      -- insert_at_top = true,
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
