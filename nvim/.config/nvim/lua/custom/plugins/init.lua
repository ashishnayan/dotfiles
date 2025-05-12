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
	-- { "rest-nvim/rest.nvim" },
	{
		"olrtg/nvim-emmet",
		config = function()
			vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
		end,
	},
	{ "vimwiki/vimwiki" },
}
