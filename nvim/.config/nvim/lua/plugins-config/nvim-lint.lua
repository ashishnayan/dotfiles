require('lint').linters_by_ft = {
  -- markdown = {'vale',},
  python = {'flake8', }
}

vim.cmd[[au BufWritePost <buffer> lua require('lint').try_lint()]]
-- vim.cmd[[au BufReadPost <buffer> lua require('lint').try_lint()]]

