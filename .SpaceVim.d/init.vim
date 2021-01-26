" ############## Default Setting Start ########################
set wrap
set guifont=JetBrainsMonoForPowerline-Regular:h20
nmap <leader>y "+y
" ############## Default Setting End   ########################


" ############## SpaceVim Setting Start ########################
" basic defualt SpaceVim settings
let g:spacevim_colorscheme  = 'sonokai'
" let g:spacevim_colorscheme  = 'molokai'
let g:spacevim_max_column   = 80
let g:spacevim_default_indent = 4
let g:spacevim_error_symbol = '✗'
let g:spacevim_warning_symbol =  '!'
let g:spacevim_info_symbol =  'i'
let g:spacevim_buffer_index_type = 4
let g:spacevim_windows_index_type = 1
let g:spacevim_lint_on_the_fly = 0
let g:spacevim_relativenumber = 1
let g:spacevim_filetree_direction = 'left'
let g:spacevim_lint_on_save = 0
let g:spacevim_enable_neomake = 0
let g:spacevim_enable_ale = 1
let g:spacevim_enable_statusline_mode = 1
let g:spacevim_windows_index_type = 3
let g:spacevim_buffer_index_type = 4
let g:spacevim_statusline_separator = 'arrow'
let g:vimtex_quickfix_enabled = 0
let g:spacevim_autocomplete_method = 'coc'

" layers settings
call SpaceVim#layers#load('checkers')
call SpaceVim#layers#load('colorscheme')
call SpaceVim#layers#load('fzf')
"call SpaceVim#layers#load('git')
call SpaceVim#layers#load('VersionControl')
call SpaceVim#layers#load('lang#c')
call SpaceVim#layers#load('lang#javascript')
"call SpaceVim#layers#load('lang#haskell')
call SpaceVim#layers#load('lang#latex')
call SpaceVim#layers#load('lang#lua')
call SpaceVim#layers#load('lang#markdown')
call SpaceVim#layers#load('lang#python')
call SpaceVim#layers#load('lang#rust')
call SpaceVim#layers#load('lang#swig')
call SpaceVim#layers#load('lang#xml')
" ############## SpaceVim Setting End  ########################


" ############## Embedded Plugins Setting Start ########################
" {{ coc {{
let g:coc_config_home = '~/.SpaceVim.d/'

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Formatting selected code.
" `<leader>f` already taken by SpaceVim 
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
" }} coc }}

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

" {{ ale {{
" setting below is not necessary when dag/vim-fish is enabled
au BufRead,BufNewFile *.fish setfiletype sh
" Disable linting for all fish files.
let g:ale_pattern_options = {'\.fish$': {'ale_enabled': 0}}
" Disable not-so-smart chktex
let g:ale_tex_chktex_executable = ''
"autocmd FileType fish let g:ale_sh_shell_default_shell='fish'
" }} ale }}

" {{ vimtex {{
" Special setting for latex files
" Use `gggqG` to format long lines in Latex
" Use `gq11j` to wrap the line you're on with the 11 below it
" Use `gqip` or `gqap` to wrap the paragraph
" gg(go to first line), gq(format) to G(the last line)
autocmd FileType tex setlocal colorcolumn=80 textwidth=79 tabstop=2 shiftwidth=2 expandtab
nnoremap <leader>v gqip
" See: http://vimdoc.sourceforge.net/htmldoc/syntax.html#g:tex_conceal
" let g:tex_conceal = "abdg"

" Disable all syntax conceal
let g:vimtex_syntax_conceal_default = 0
" Disable automatic view since I do not use `previewer` for viewing anymore
let g:vimtex_view_automatic = 0
" }} vimtex }}
" ############## Embedded Plugins Setting End   ########################


" ############## Extra Plugins Setting Start ########################
" No longer use YouCompleteMe anymore
" {{ YouCompleteMe {{
let g:spacevim_enable_ycm = 0
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
" No longer use rdnetto/YCM-Generator
let g:spacevim_custom_plugins = [
    \ ['machakann/vim-highlightedyank'],
    \ ['iloginow/vim-stylus'],
    \ ['sainnhe/sonokai'],
    \ ['sheerun/vim-polyglot'], 
    \ ]
" ############## Custom Plugins in SpaceVim End   ########################


" ############## Custom Plugins Setting in SpaceVim Start ########################
let g:sonokai_style = 'default'
let g:sonokai_better_performance = 1
" ############## Custom Plugins Setting in SpaceVim End  ########################
