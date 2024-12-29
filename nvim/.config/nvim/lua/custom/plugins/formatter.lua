return {
  -- Autoformatting
  {
    "stevearc/conform.nvim",
    -- event = { "BuffReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          javascriptreact = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          yml = { "prettier" },
          lua = { "stylua" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout = 1000,
        },
      })
    end
  }

}
