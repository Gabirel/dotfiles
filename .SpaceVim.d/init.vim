let g:spacevim_colorscheme  =   'molokai'
let g:spacevim_max_column   =   80
let g:spacevim_error_symbol =   '✗'
let g:spacevim_buffer_index_type = 4
let g:spacevim_lint_on_the_fly = 0
set norelativenumber
" call layers settings
call SpaceVim#layers#load('lang#c')
call SpaceVim#layers#load('lang#javascript')
call SpaceVim#layers#load('lang#haskell')
call SpaceVim#layers#load('lang#lua')
call SpaceVim#layers#load('lang#markdown')
call SpaceVim#layers#load('lang#python')
call SpaceVim#layers#load('lang#swig')
call SpaceVim#layers#load('lang#xml')
"call SpaceVim#layers#load('tmux')
nnoremap <leader>svf :source ~/.SpaceVim.d/init.vim<cr>
let g:neomake_open_list = 0
let g:mkdp_path_to_chrome = 'google-chrome-stable'
let g:mkdp_auto_start = 0
let vim_markdown_preview_github=1
let vim_markdown_preview_use_xdg_open=1
let g:spacevim_lint_on_save = 0
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
" If I enable this feature, it's gonna slow down my vim
let g:spacevim_auto_disable_touchpad = 0
let g:spacevim_lint_on_save = 0
