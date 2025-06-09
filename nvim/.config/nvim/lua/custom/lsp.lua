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
	init_options = {
		settings = {
			-- Server settings should go here
			lineLength = 131,
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
	},
	automatic_enable = true,
})
