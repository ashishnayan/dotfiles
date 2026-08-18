return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.install").prefer_git = true

			-- Highlighting and query mapping are now integrated natively.
			-- You only need to declare your preferred language parsers:
			local builtin = {
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
				"markdown",
				"markdown_inline",
				"latex",
				"yaml",
			}

			-- Installs missing parsers automatically on startup
			for _, lang in ipairs(builtin) do
				pcall(vim.cmd.TSInstall, lang)
			end
		end,
	},
}
