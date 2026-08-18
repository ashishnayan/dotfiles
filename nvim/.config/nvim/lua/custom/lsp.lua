-- vim.lsp.config("pylsp", {
-- 	settings = {
-- 		pylsp = {
-- 			plugins = {
-- 				flake8 = {
-- 					enabled = true,
-- 					-- config = "/home/ashish/.flake8",
-- 					ignore = { "W503", "W391" },
-- 					maxLineLength = 131,
-- 				},
-- 				black = {
-- 					line_length = 100,
-- 				},
-- 			},
-- 		},
-- 	},
-- })
vim.lsp.config('ruff', {
	cmd = { "ruff", "server" },
	root_markers = { 'pyproject.toml', '.venv', 'ruff.toml', '.git' },
	init_options = {
		settings = {
			-- Server settings should go here
			lineLength = 100,
			organizeImports = true,
			logLevel = "info",
			logFile = "~/ruff.log",
			fix = true,
			lint = {
				preview = true,
				select = { "E", "F", "I", },
				extendSelect = { "W" },
			}
		}
	}
})
vim.lsp.config('ty', {
	cmd = { "ty", "server" },
	root_markers = { 'pyproject.toml', '.venv', 'ruff.toml', '.git' },
})
vim.lsp.enable('ruff')
vim.lsp.enable('ty')
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		-- "pylsp",
		"ruff",
		"ts_ls",
		"jsonls",
		"html",
		"cssls",
		"ty",
		"marksman",
	},
	automatic_enable = true,
})
