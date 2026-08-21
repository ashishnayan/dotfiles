-- Postman-in-Neovim: plain-text `.http` files, run with <leader>Rr
-- Requires `curl`. Optional: `jq` (json), `grpcurl` (gRPC), `websocat` (ws).
return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    dependencies = { "saghen/blink.cmp" },
    init = function()
      -- .http / .rest files -> `http` filetype (also what tree-sitter wants)
      vim.filetype.add({
        extension = {
          http = "http",
          rest = "http",
        },
      })
    end,
    opts = {
      -- I bind everything myself below, so keep kulala's own maps off
      global_keymaps = false,
      -- Env block used until you pick another with <leader>Re
      default_env = "dev",
      -- "g" = vars captured from a response are visible in every buffer, like
      -- Postman's environment. "b" (kulala's default) scopes them per buffer,
      -- which breaks token-in-one-file/use-in-another flows.
      environment_scope = "g",
      ui = {
        display_mode = "split",
        split_direction = "right",
        default_view = "body",
      },
      -- Built-in LSP: completion, hover, code actions, diagnostics for .http.
      -- blink.cmp's `lsp` source picks it up automatically.
      lsp = {
        enable = true,
      },
    },
    keys = {
      -- Available anywhere: these two also load the plugin on first press
      { "<leader>Rs", function() require("kulala").scratchpad() end,        desc = "Kulala scratchpad" },
      { "<leader>Rc", function() require("kulala").from_curl() end,         desc = "Paste curl as request" },

      -- Inside .http buffers
      { "<leader>R",  nil,                                                 desc = "REST/Kulala",             ft = { "http", "rest" } },
      { "<leader>Rr", function() require("kulala").run() end,               desc = "Run request under cursor", ft = { "http", "rest" } },
      { "<leader>Ra", function() require("kulala").run_all() end,           desc = "Run all requests in file", ft = { "http", "rest" } },
      { "<leader>RR", function() require("kulala").replay() end,            desc = "Replay last request",     ft = { "http", "rest" } },
      { "<leader>Rv", function() require("kulala").toggle_view() end,       desc = "Toggle body/headers view", ft = { "http", "rest" } },
      { "<leader>Ri", function() require("kulala").inspect() end,           desc = "Inspect resolved request", ft = { "http", "rest" } },
      { "<leader>Ry", function() require("kulala").copy() end,              desc = "Copy request as curl",    ft = { "http", "rest" } },
      { "<leader>Re", function() require("kulala").set_selected_env() end,  desc = "Select environment",      ft = { "http", "rest" } },
      { "<leader>Ru", function() require("kulala.ui.auth_manager").open_auth_config() end, desc = "Auth config manager", ft = { "http", "rest" } },
      { "<leader>Rf", function() require("kulala").search() end,            desc = "Find requests in project", ft = { "http", "rest" } },
      { "<leader>Rq", function() require("kulala").close() end,             desc = "Close response window",   ft = { "http", "rest" } },
      { "]r",         function() require("kulala").jump_next() end,         desc = "Next request",            ft = { "http", "rest" } },
      { "[r",         function() require("kulala").jump_prev() end,         desc = "Previous request",        ft = { "http", "rest" } },
    },
  },
}
