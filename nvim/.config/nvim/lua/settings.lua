HOME = os.getenv("HOME")
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

-- basic settings
vim.o.encoding = "utf-8"
vim.o.hidden = true
vim.o.backspace = "indent,eol,start" -- backspace works on every char in insert mode
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.history = 1000
vim.o.startofline = true
vim.cmd([[ set termguicolors ]])

-- Mapping waiting time
vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 100

-- Display
vim.o.showmatch  = true -- show matching brackets
vim.o.scrolloff = 3 -- always show 3 rows from edge of the screen
vim.o.synmaxcol = 300 -- stop syntax highlight after x lines for performance
vim.o.laststatus = 2 -- always show status line

vim.o.list = true -- do not display white characters
-- vim.opt.listchars:append("space:⋅")
vim.o.foldenable = false
vim.o.foldlevel = 4 -- limit folding to 4 levels
vim.o.foldmethod = 'syntax' -- use language syntax to generate folds
vim.o.wrap = false --do not wrap lines even if very long
vim.o.eol = false -- show if there's no eol char
vim.o.showbreak= '↪' -- character to show when line is broken

-- Sidebar
vim.o.relativenumber = true -- line number on the left
vim.o.numberwidth = 3 -- always reserve 3 spaces for line number
vim.o.signcolumn = 'yes' -- keep 1 column for coc.vim  check
vim.o.modelines = 0
vim.o.showcmd = true -- display command in bottom bar

-- Search
vim.o.incsearch = true -- starts searching as soon as typing, without enter needed
vim.o.ignorecase = true -- ignore letter case when searching
vim.o.smartcase = true -- case insentive unless capitals used in search

vim.o.matchtime = 2 -- delay before showing matching paren
vim.o.mps = vim.o.mps .. ",<:>"


-- White characters
vim.o.autoindent = true
-- vim.o.smartindent = true
vim.o.tabstop = 2 -- 1 tab = 2 spaces
vim.o.shiftwidth = 2 -- indentation rule
vim.o.formatoptions = 'qnj1' -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word
vim.o.expandtab = true -- expand tab to spaces

vim.cmd([[
  au FileType python                  set ts=4 sw=4 softtabstop=4
  au BufRead,BufNewFile *.md          set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.ppmd        set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.markdown    set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.slimbars    set syntax=slim
]])

-- Commands mode
vim.o.wildmenu = true -- on TAB, complete options for system command
vim.o.wildignore = 'deps,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc'

-- Only show cursorline in the current window and in normal mode.
vim.cmd([[
  augroup cline
      au!
      au WinLeave * set nocursorline
      au WinEnter * set cursorline
      au InsertEnter * set nocursorline
      au InsertLeave * set cursorline
  augroup END
]])

-- Highlight on yank
-- vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'
-- vim.cmd 'au TextYankPost * lua vim.highlight.on_yank{higroup="ToolbarButton", timeout=500}'
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- vim.cmd 'au TextYankPost * lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


vim.g.python3_host_prog = "/Users/ashishnayan/.pyenv/shims/python3"
vim.g.python_host_prog = "/Users/ashishnayan/.pyenv/shims/python2"
-- vim.cmd[[au FileType python setlocal formatprg=autopep8\ -]]

-- VimWiki
vim.cmd[[let g:vimwiki_list= [{'path': '~/Documents/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}] ]]

-- Trim trailing whitespaces
-- vim.cmd[[
--   autocmd BufWritePre *.py,*.lua,*.sql,*.js,*.jsx,*.ts,*.tsx,*.css :%s/\s\+$//e
-- ]]
local group = vim.api.nvim_create_augroup("Formatter", {clear=true})
vim.api.nvim_create_autocmd(
  "BufWritePre",
  {
    pattern={"*.py", "*.lua", "*.sql", "*.js", "*.jsx", "*.ts", "*.tsx", "*.css"},
    command='%s/\\s\\+$//e',
    group=group,
  }
)
-- vim.cmd[[
--  autocmd BufWritePost  *.py :Format
-- ]]
vim.api.nvim_create_autocmd("BufWritePre", {pattern={"*.py"}, command="Format", group=group})

vim.g.pyindent_open_paren = ''
-- vim.cmd[[]]
-- vim.g.pyindent_searchpair_timeout = 500
