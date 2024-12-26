require("telescope").setup {
  defaults = {
    file_ignore_patterns = { "dune.lock" },
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
    wrap_results = true,

    fzf = {},
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },
}

pcall(require("telescope").load_extension, "fzf")
-- pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")

-- keymaps
local builtin = require "telescope.builtin"

vim.keymap.set("n", "<space>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<space>ft", function()
  return builtin.git_files { cwd = vim.fn.expand "%:h" }
end, { desc = "Find git files" })
vim.keymap.set("n", "<space>fh", builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<space>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<space>fb", builtin.buffers, { desc = "Find in Buffers" })
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find, { desc = "Current buffer fuzzy find" })
vim.keymap.set("n", "<space>fr", builtin.registers, { desc = "Registers" })
vim.keymap.set("n", "<space>fi", "<cmd>Telescope import<cr>", { desc = "Import" })

vim.keymap.set("n", "<space>fw", builtin.grep_string, { desc = "Grep string" })

-- nvim edit config
vim.keymap.set("n", "<space>eo", function()
  builtin.find_files { cwd = "~/.config/nvim/" }
end, { desc = "Edit nvim config" })
