let g:spacevim_colorscheme  =   'molokai'
let g:spacevim_max_column   =   80
let g:spacevim_error_symbol =   '✗'
let g:spacevim_buffer_index_type = 4
"let g:spacevim_custom_plugins=[
"            \ ['SpaceVim/vim-luacomplete'],
"            \
call SpaceVim#layers#load('lang#c')
call SpaceVim#layers#load('lang#javascript')
call SpaceVim#layers#load('lang#lua')
call SpaceVim#layers#load('lang#markdown')
call SpaceVim#layers#load('lang#swig')
call SpaceVim#layers#load('lang#xml')
"call SpaceVim#layers#load('tmux')
nnoremap <leader>svf :source ~/.SpaceVim.d/init.vim<cr>
