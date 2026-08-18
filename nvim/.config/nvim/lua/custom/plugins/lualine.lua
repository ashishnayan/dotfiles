return {
  { -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {},
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end } },
          lualine_b = { {
            "branch",
            fmt = function(str)
              if #str > 20 then
                return str:sub(1, 20) .. '...'
              end
              return str
            end
          }, "diff", { "diagnostics", sources = { "nvim_diagnostic", "coc" } } },
          lualine_c = { {
            "filename",
            file_status = true,
            path = 4,
            symbols = {
              modified = ' ●', -- Text to show when the file is modified.
              readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
            }
          } },
          lualine_x = { "filetype" },
          lualine_y = { "progress", "searchcount" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        -- tabline = {
        --   lualine_a = { "buffers" },
        --   lualine_b = {},
        --   lualine_c = {},
        --   lualine_x = {},
        --   lualine_y = {},
        --   lualine_z = { "tabs" },
        -- },
        winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {},
      })
    end,
  },
}
