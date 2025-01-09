return {
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  { "tpope/vim-sleuth" },
  {
    "echasnovski/mini.icons",
    version = "*",
  },
  -- { "github/copilot.vim" },
  {
    "zbirenbaum/copilot.lua",

    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  -- {"zbirenbaum/copilot-cmp"},
  { "giuxtaposition/blink-cmp-copilot" },
  { "vimwiki/vimwiki" },
}
