return {
	{ -- Highlight, edit, and navigate code
		enabled = true,
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		branch = "main",
		lazy = false,
		config = function()
			require("treesitter")
		end,
	},
}
