local nvim_lsp = require('lspconfig')
require('nvim-lsp-installer')
local null_ls = require("null-ls")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gv', '<cmd>vsplit<CR><cmd>lua vim.lsp.buf.definition()<CR><C-w>r', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  if client.name == "pylsp" then
    client.server_capabilities.document_formatting = false
  end

  if client.server_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { 'jedi_language_server', 'jsonls'}
local servers = { 'pylsp', 'jsonls', 'tsserver', 'eslint', 'cssls', 'jdtls' }
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, lsp in ipairs(servers) do
  if (lsp == 'tsserver')
  then
    nvim_lsp.tsserver.setup({
      on_attach = function(client, bufnr)
          local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          local opts = { noremap=true, silent=true }
          client.server_capabilities.document_formatting = false
          client.server_capabilities.document_range_formatting = false
          local ts_utils = require("nvim-lsp-ts-utils")
          ts_utils.setup({})
          ts_utils.setup_client(client)
          buf_set_keymap("n", "gs", "<cmd>TSLspOrganize<CR>", opts)
          buf_set_keymap("n", "gi", "<cmd>TSLspRenameFile<CR>", opts)
          buf_set_keymap("n", "go", "<cmd>TSLspImportAll<CR>", opts)
          on_attach(client, bufnr)
      end,
    })
  else
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            flake8 = {
              maxLineLength = 131,
              ignore = "W503,W391"
            }
          }
        }
      }
    }
  end
end

null_ls.setup({
    sources = {
        -- null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.black.with { extra_args = {"--line-length=130"}},
        -- null_ls.builtins.completion.spell,
    },
    on_attach = on_attach,
})
-- vim.cmd[[autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx :EslintFixAll]]
