return {
	{ -- Highlight, edit, and navigate code
		enabled = true,
		"nvim-treesitter/nvim-treesitter",
		-- dependencies = {
		-- 	-- "nvim-treesitter/nvim-treesitter-textobjects",
		-- },
		build = ":TSUpdate",
		lazy = true,
		config = function()
			-- require("custom.treesitter")
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"c",
					"python",
					"tsx",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"elixir",
					"heex",
					"javascript",
					"typescript",
					"html",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
