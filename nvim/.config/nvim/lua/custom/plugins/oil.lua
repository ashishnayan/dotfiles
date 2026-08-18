return {
  {
    'stevearc/oil.nvim',
    opts = {},
    view_options = {
      -- Automatically collapse empty nested directories
      skip_empty_dirs = true,
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup()
      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
