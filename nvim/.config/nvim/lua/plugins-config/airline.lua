vim.cmd([[
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#buffer_nr_show = 1
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''
  let g:airline_theme="night_owl"   " <theme> is a valid theme name

  let g:airline_extensions = ['branch', 'tabline', 'virtualenv']
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#branch#enabled=1
  let g:airline#extensions#hunks#enabled = 1
  let g:airline_section_b = airline#section#create_left(['branch','hunks'])
]])
