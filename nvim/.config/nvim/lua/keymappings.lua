-- split nav
tmap('<C-h>', '<C-\\><C-N><C-w>h')
tmap('<C-j>', '<C-\\><C-N><C-w>j')
tmap('<C-k>', '<C-\\><C-N><C-w>k')
tmap('<C-l>', '<C-\\><C-N><C-w>l')
imap('<C-h>', '<C-\\><C-N><C-w>h')
imap('<C-j>', '<C-\\><C-N><C-w>j')
imap('<C-k>', '<C-\\><C-N><C-w>k')
imap('<C-l>', '<C-\\><C-N><C-w>l')
nmap('<C-h>', '<C-w>h')
nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-l>', '<C-w>l')

vmap("J", ":m '>+1<CR>gv=gv")
vmap("K", ":m '<-2<CR>gv=gv")

tmap('<Esc><Esc>', '<C-\\><C-n>')

-- Clipboard
nmap('<leader>y', '"+y')
nmap('<leader>Y', '"+Y')
vmap('<leader>y', '"+y')
vmap('<leader>Y', '"+Y')

nmap('<leader>p', '"+p')
nmap('<leader>P', '"+P')

-- Telescope KeyMappings
nmap('<leader>ff', '<cmd>Telescope find_files<cr>')
nmap('<leader>fg', '<cmd>Telescope live_grep<cr>')
nmap('<leader>fb', '<cmd>Telescope buffers<cr>')
nmap('<leader>fh', '<cmd>Telescope help_tags<cr>')

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })


-- Floaterm KeyMappings
-- nmap('<leader>r', '<cmd>FloatermNew --wintype=flaot --opener=tabe --height=0.8 --width=0.8 --name=ranger ranger<CR>')
-- nmap('<leader>tt', '<cmd>FloatermToggle --wintype=flaot --height=0.8 --width=0.8<CR>')
-- nmap('<leader>gg', '<cmd>FloatermNew --wintype=float --height=0.8 --width=0.8 --name=lazygit lazygit<CR>')
--

-- Nvim-Tree KeyMappings
nmap('<leader>nt', '<cmd>NvimTreeToggle<CR>')
nmap('<leader>nr', '<cmd>NvimTreeRefresh<CR>')
nmap('<leader>nf', '<cmd>NvimTreeFindFile<CR>')

-- Nav buffers
vim.api.nvim_set_keymap('n', 'gb', '<cmd>bn<CR>', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', 'gB', '<cmd>bp<CR>', {noremap=false, silent=true})

-- nmap('<leader>"', 'ciw"<C-r>-"')
-- nmap("<leader>'", "ciw'<C-r>-'")
-- imap('"', '""<left>')
-- imap("'", "''<left>")
-- imap("(", "()<left>")
-- imap('[', '[]<left>')
-- imap('{', '{}<left>')

-- Vimspector
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>call vimspector#Launch()<CR>', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', '<leader>dr', '<cmd>VimspectorReset<CR>', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', '<leader>de', '<Plug>VimspectorEval', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', '<leader>dw', '<Plug>VimspectorWatch', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', '<leader>do', '<Plug>VimspectorShowOutput', {noremap=false, silent=true})
-- nmap <leader>vi <Plug>VimspectorBalloonEval
vim.api.nvim_set_keymap('n', '<leader>di', '<Plug>VimspectorBalloonEval', {noremap=false, silent=true})
-- xmap <leader>vi <Plug>VimspectorBalloonEval
vim.api.nvim_set_keymap('x', '<leader>di', '<Plug>VimspectorBalloonEval', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', '<leader>db', '<Plug>VimspectorToggleBreakpoint', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', '<leader>dl', '<Plug>VimspectorStepInto', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', '<leader>dj', '<Plug>VimspectorStepOver', {noremap=false, silent=true})
vim.api.nvim_set_keymap('n', '<leader>dk', '<Plug>VimspectorStepOut', {noremap=false, silent=true})

nmap("<leader>dc", "<cmd>call vimspector#Continue()<CR>")

-- Maximizer
-- nmap("<leader>m", "<cmd>MaximizerToggle<CR>")
-- vmap("<leader>m", "<cmd>MaximizerToggle<CR>gv")
-- imap("<leader>m", "<C-o><cmd>MaximizerToggle<CR>")
--
-- Vim-Startify
nmap("<leader>a", "<cmd>Startify<CR>")

-- LspSaga
-- nmap("gl", "<cmd>Lspsaga lsp_finder<CR>")
-- nmap("<leader>ca", "<cmd>Lspsaga code_action<CR>")
-- vmap("<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>")
-- nmap("K", "<cmd>Lspsaga hover_doc<CR>")
-- -- scroll down hover doc or scroll in definition preview
-- nmap("<C-f>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
-- -- scroll up hover doc
-- nmap("<C-b>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
-- nmap("gs", "Lspsaga signature_help<CR>")
-- nmap("gr", "Lspsaga rename<CR>")
-- nmap("[e", "Lspsaga diagnostic_jump_next<CR>")
-- nmap("]e", "Lspsaga diagnostic_jump_prev<CR>")


-- Diagnostic Keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Bufferline
-- nmap("<leader>v", "<cmd>BufferLinePick<CR>")
