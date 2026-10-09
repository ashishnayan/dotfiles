return {
  {
    "nvim-java/nvim-java",
    config = function()
      require("java").setup({
        jdk = {
          path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
          auto_install = false, -- Prevent it from downloading its own JDK
        },
      })
      vim.lsp.enable("jdtls")
    end,
  },
}
