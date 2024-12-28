local HOME           = os.getenv("HOME")
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- basic settings
vim.o.inccommand     = 'split'
vim.o.encoding       = "utf-8"
vim.o.hidden         = true
vim.o.backspace      = "indent,eol,start" -- backspace works on every char in insert mode
vim.o.completeopt    = 'menu,menuone,noselect'
vim.o.history        = 1000
vim.o.startofline    = true

-- Mapping waiting time
vim.o.timeout        = false
vim.o.ttimeout       = true
vim.o.ttimeoutlen    = 100

-- Display
vim.o.showmatch      = true -- show matching brackets
vim.o.scrolloff      = 3    -- always show 3 rows from edge of the screen
vim.o.synmaxcol      = 300  -- stop syntax highlight after x lines for performance
vim.o.laststatus     = 2    -- always show status line

vim.o.list           = true -- do not display white characters
-- vim.opt.listchars:append("space:⋅")
vim.o.foldenable     = true
vim.o.foldlevel      = 99 -- limit folding to 4 levels
vim.o.foldcolumn     = '0'
-- vim.o.foldmethod     = 'expr' -- use language syntax to generate folds
vim.o.wrap           = false --do not wrap lines even if very long
vim.o.eol            = false -- show if there's no eol char
vim.o.showbreak      = '↪' -- character to show when line is broken

-- Sidebar
vim.o.relativenumber = true  -- line number on the left
vim.o.numberwidth    = 3     -- always reserve 3 spaces for line number
vim.o.signcolumn     = 'yes' -- keep 1 column for coc.vim  check
vim.o.modelines      = 0
vim.o.showcmd        = true  -- display command in bottom bar

-- Search
vim.o.incsearch      = true -- starts searching as soon as typing, without enter needed
vim.o.ignorecase     = true -- ignore letter case when searching
vim.o.smartcase      = true -- case insentive unless capitals used in search

vim.o.matchtime      = 2    -- delay before showing matching paren
vim.o.mps            = vim.o.mps .. ",<:>"


-- White characters
vim.o.autoindent = true
-- vim.o.smartindent = true
vim.o.tabstop = 2      -- 1 tab = 2 spaces
vim.o.shiftwidth = 2   -- indentation rule
vim.o.formatoptions =
'qnj1'                 -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word
vim.o.expandtab = true -- expand tab to spaces
vim.o.lcs = 'tab:│ ,trail:-,nbsp:+'

-- Spell check
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

vim.o.colorcolumn = "130"

vim.cmd([[
  au BufRead,BufNewFile *.md          set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.ppmd        set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.markdown    set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.slimbars    set syntax=slim
]])

-- Commands mode
vim.o.wildmenu = true -- on TAB, complete options for system command
vim.o.wildignore =
'deps,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc'

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

vim.g.python3_host_prog = HOME .. "/.pyenv/versions/py3.11nvim/bin/python3"
vim.g.python_host_prog = HOME .. "/.pyenv/versions/py2nvim/bin/python2"

-- VimWiki
vim.cmd [[let g:vimwiki_list= [{'path': '$HOME/Documents/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}] ]]

local group = vim.api.nvim_create_augroup("Formatter", { clear = true })
vim.api.nvim_create_autocmd(
  "BufWritePre",
  {
    pattern = { "*.py", "*.lua", "*.sql", "*.js", "*.jsx", "*.ts", "*.tsx",
      "*.css", "*.go", "*.yml", "*.yaml", "*.rs", "*.json", "*.toml" },
    command = '%s/\\s\\+$//e',
    group = group,
  }
)
vim.api.nvim_create_autocmd("BufWritePre",
  {
    pattern = {
      "*.py", "*.go", "*.tsx", "*.jsx", "*.js", "*.css", "*.lua", "*.rs", "*.json", "*.toml", "*.yaml", "*.yml", "*.sql",
      "*.html", "*.xml", "*.md", "*.markdown", "*.sh", "*.bash", "*.zsh", "*.fish", "*.c", "*.cpp", "*.h", "*.hpp",
      "*.java",
    },
    command = "Format",
    group = group
  })

vim.g.pyindent_open_parent = ''
