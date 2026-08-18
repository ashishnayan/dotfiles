return { {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = {
    -- Enforce rendering across all typical markdown variations
    preview = {
      filetypes = { "md", "markdown", "rmd", "quarto", "mkd", },
    }
  },
  config = function()
    require("markview").setup({
      preview = {
        enable = false,
        map_gx = true, -- Ensures 'gx' is mapped to node handling
      },
      experimental = {
        prefer_nvim = true, -- Tells 'gx' to open local files inside a Neovim buffer instead of a web browser!
      },
      -- 1. FINE-TUNED WIKI LINKS (Obsidian Style)
      links = {
        enable = true,
        wiki_links = {
          enable = true,
          corner_left = "[[",
          corner_right = "]]",
          -- Links inherit Catppuccin's beautiful Blue accent color
          hl = "CatppuccinBlue",
        }
      },

      -- 2. CUSTOM CATPPUCCIN HEADER BLOCKS
      headings = {
        enable = true,
        heading_1 = {
          style = "bordered", -- Solid look with an underline boundary
          hl = "CatppuccinRed",
          icon = "   ",
        },
        heading_2 = {
          style = "bordered",
          hl = "CatppuccinPeach",
          icon = "   ",
        },
        heading_3 = {
          style = "simple", -- Clean look without heavy padding
          hl = "CatppuccinGreen",
          icon = "   ",
        },
        heading_4 = {
          style = "simple",
          hl = "CatppuccinSapphire",
          icon = "   ",
        }
      },
    });

    vim.api.nvim_set_keymap("n", "<leader>tm", "<CMD>Markview splitToggle<CR>",
      { desc = "Toggles `markview` previews globally." });
  end,
  -- Completion for `blink.cmp`
  -- dependencies = { "saghen/blink.cmp" },
}, };
