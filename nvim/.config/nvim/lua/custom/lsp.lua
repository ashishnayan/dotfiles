vim.lsp.config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				flake8 = {
					enabled = true,
					-- config = "/home/ashish/.flake8",
					ignore = { "W503", "W391" },
					maxLineLength = 131,
				},
				black = {
					line_length = 100,
				},
			},
		},
	},
})
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pylsp",
		"ts_ls",
		"jsonls",
		"html",
		"cssls",
	},
	automatic_enable = true,
})
