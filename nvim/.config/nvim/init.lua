-- Sensible defaults
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.termguicolors = true
vim.o.termguicolors = true
vim.diagnostic.config({
	virtual_lines = { current_line = true },
})

-- Lazy Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/custom/plugins/` folder
require("lazy").setup({ import = "custom/plugins" }, {
	change_detection = {
		notify = false,
	},
})

require("colorschemes.catppuccin")
