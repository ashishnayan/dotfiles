-- local fn = vim.fn
-- local execute = vim.api.nvim_command
--
-- Sensible defaults
require('settings')

-- Packer Configurations
-- local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
--   if fn.empty(fn.glob(install_path)) > 0 then
--     execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
--   end
--   vim.cmd [[packadd packer.nvim]]
--   vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua
--
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

-- Install plugins
-- require('plugins')
require('plugins_lazy')

-- Utils
require('utils')

-- Keymappings
require('keymappings')

-- Configs
require('plugins-config.telescope')
require('plugins-config.lualine')

-- require('plugins-config.airline')
-- require('plugins-config.lspsaga')

require('plugins-config.nvim-cmp')
require('plugins-config.lsp')
require('plugins-config.lightspeed')
require('plugins-config.vimspector')
require('plugins-config.vim-startify')
require('plugins-config.comment')
require('plugins-config.todo-comment')
-- require("plugins-config.bufferline")
require("plugins-config.nvim-autopair")
require("plugins-config.gitsigns")
require("plugins-config.mason")
require("plugins-config.treesitter")

-- ColorScheme  --
vim.o.background = 'dark'

-- Tokoyodark
-- require('plugins-config.tokyodark')
-- vim.cmd("colorscheme tokyodark")
-- vim.cmd("hi Visual cterm=reverse gui=reverse")
-- cterm=reverse ctermbg=242 gui=reverse guibg=DarkGrey
-- GruvBox Material
-- vim.cmd[[
--   let g:gruvbox_material_background = 'hard'
--   let g:gruvbox_material_transparent_background = 1
--   let g:gruvbox_material_diagnostic_text_highlight = 1
--   let g:gruvbox_material_diagnostic_line_highlight = 1
--   let g:gruvbox_material_diagnostic_virtual_text = 'colored'
--   let g:gruvbox_material_visual = 'reverse'
--   colorscheme gruvbox-material
-- ]]

-- Vscode 
-- vim.g.vscode_style = "dark"
-- vim.cmd[[colorscheme vscode]]

-- Onedark
-- vim.g.onedark_terminal_italics = true
-- vim.cmd[[colorscheme onedark]]


-- Oceanic-Next
-- vim.cmd[[
--   let g:oceanic_next_terminal_bold = 1
--   let g:oceanic_next_terminal_italic = 1
--   colorscheme OceanicNext
-- ]]

-- nightfox
-- require("plugins-config.nightfox")
-- vim.cmd[[
--  colorscheme nightfox
-- ]]
