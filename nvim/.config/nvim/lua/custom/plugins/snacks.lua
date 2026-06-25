return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      notifier = {
        enabled = true,
        style = "compact",
        timeout = 2500,
      },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { "<leader>tt", function() Snacks.terminal() end,                                                                desc = "Toggle Terminal" },
      { "<leader>o",  function() Snacks.terminal.toggle("opencode", { win = { position = "right", width = 60 } }) end, desc = "Toggle Opecode in Terminal" },
      { "<leader>n",  function() Snacks.notifier.show_history() end,                                                   desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end,                                                           desc = "Dismiss All Notifications" },
      { "<leader>gB", function() Snacks.gitbrowse() end,                                                               desc = "Git Browse",                  mode = { "n", "v" } },
      { "<leader>gf", function() Snacks.lazygit.log_file() end,                                                        desc = "Lazygit Current File History" },
      { "<leader>gg", function() Snacks.lazygit() end,                                                                 desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end,                                                             desc = "Lazygit Log (cwd)" },
      { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end,                                               desc = "Buffer Diagnostics" },
      { "<leader>:",  function() Snacks.picker.command_history() end,                                                  desc = "Command History" },
      { "<leader>sb", function() Snacks.picker.lines() end,                                                            desc = "Buffer Lines" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,                          desc = "Find Config File" },
      { "<leader>e",  function() Snacks.explorer() end,                                                                desc = "File Explorer" },
      { "<leader>fr", function() Snacks.picker.recent() end,                                                           desc = "Recent" },
    },
  },
}
