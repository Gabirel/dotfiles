" ############## Default Setting Start ########################
set wrap
au BufRead,BufNewFile *.fish setfiletype sh
set guifont=Menlo-Regular:h20
" ############## Default Setting End   ########################


" ############## SpaceVim Setting Start ########################
" basic defualt SpaceVim settings
let g:spacevim_colorscheme  = 'molokai'
let g:spacevim_max_column   = 80
let g:spacevim_default_indent = 4
let g:spacevim_error_symbol = '✗'
let g:spacevim_warning_symbol =  '!'
let g:spacevim_info_symbol =  'i'
let g:spacevim_buffer_index_type = 4
let g:spacevim_windows_index_type = 1
let g:spacevim_lint_on_the_fly = 0
let g:spacevim_relativenumber = 0
let g:spacevim_filetree_direction = 'left'
let g:spacevim_lint_on_save = 0
let g:neomake_open_list = 0
let g:vimtex_quickfix_enabled = 0

" layers settings
call SpaceVim#layers#load('colorscheme')
"call SpaceVim#layers#load('git')
call SpaceVim#layers#load('VersionControl')
call SpaceVim#layers#load('lang#c')
call SpaceVim#layers#load('lang#javascript')
"call SpaceVim#layers#load('lang#haskell')
call SpaceVim#layers#load('lang#latex')
call SpaceVim#layers#load('lang#lua')
call SpaceVim#layers#load('lang#markdown')
call SpaceVim#layers#load('lang#python')
call SpaceVim#layers#load('lang#swig')
call SpaceVim#layers#load('lang#xml')
" ############## SpaceVim Setting End  ########################


" ############## Embedded Plugins Setting Start ########################
" {{ vim_markdown {{
let g:mkdp_path_to_chrome = 'google-chrome-stable'
let g:mkdp_auto_start = 0
let vim_markdown_preview_github=1
let vim_markdown_preview_use_xdg_open=1
" }} vim_markdown }}

" {{ Neoformat {{
" Auto format on save
"augroup fmt
"  autocmd!
"  autocmd BufWritePre * undojoin | Neoformat
"augroup END

let g:neoformat_cpp_clangformat = {
            \ 'exe': 'clang-format',
            \ 'args': ['-style=file'],
            \ 'stdin': 1,
            \ }
" }} Neoformat }}
"
" {{ vimtex {{
" Special setting for latex files
" Use `gggqG` to format long lines in Latex
" Use `gq11j` to wrap the line you're on with the 11 below it
" Use `gqip` or `gqap` to wrap the paragraph
" gg(go to first line), gq(format) to G(the last line)
autocmd FileType tex setlocal colorcolumn=80 textwidth=79 tabstop=2 shiftwidth=2 expandtab
nnoremap <leader>v gqip
" See: http://vimdoc.sourceforge.net/htmldoc/syntax.html#g:tex_conceal
let g:tex_conceal = "abdg"
" Disable automatic view since I do not use `previewer` for viewing anymore
let g:vimtex_view_automatic = 0
" }} vimtex }}
" ############## Embedded Plugins Setting End   ########################


" ############## Extra Plugins Setting Start ########################
" {{ YouCompleteMe {{
let g:spacevim_enable_ycm = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 0
let g:ycm_error_symbol = '✗'
let g:ycm_warning_symbol = '!'
let g:ycm_global_ycm_extra_conf = '~/.SpaceVim.d/.ycm_extra_conf.py'
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \ }
let g:ycm_filetype_blacklist = { }
" YCM for vimtex
au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme
" }} YouCompleteMe }}
" ############## Extra Plugins Setting End   ########################


" ############## Custom Plugins in SpaceVim Start ########################
let g:spacevim_custom_plugins = [
    \ ['rdnetto/YCM-Generator'],
    \ ]
" ############## Custom Plugins in SpaceVim End   ########################


" ############## Custom Plugins Setting in SpaceVim Start ########################

" ############## Custom Plugins Setting in SpaceVim End  ########################
