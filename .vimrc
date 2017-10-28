if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state(expand('~/.vim/dein'))
  call dein#begin(expand('~/.vim/dein'))
  call dein#add('powerline/powerline', {'rtp': 'powerline/bindings/vim/'})
  call dein#add('haya14busa/incsearch.vim')
  call dein#add('Shougo/neocomplcache.vim')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('derekwyatt/vim-scala')
  call dein#add('leftouterjoin/changed')
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable


"""""""""""
" general "
"""""""""""
colorscheme default
set t_Co=256

set number

set expandtab
set tabstop=2
set shiftwidth=2

set cursorline
set cursorcolumn
highlight CursorColumn ctermbg=233

set ambiwidth=double

set whichwrap+=h,l,<,>,[,],b,s

set backspace=indent,eol,start

set wildmode=list,full

set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:&

set clipboard=unnamed

set ignorecase

set scrolloff=999

set ttyfast

set mouse=a

nnoremap ; :
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""
" powerline "
"""""""""""""
let g:powerline_pycmd="python3"
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""
" incsearch "
"""""""""""""
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""
" indent-guides "
"""""""""""""""""
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors=0
hi IndentGuidesOdd ctermbg=234
hi IndentGuidesEven ctermbg=236
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""
" neocomplcache "
"""""""""""""""""
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
" sable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
        \ }

        " Plugin key-mappings.
        inoremap <expr><C-g>     neocomplcache#undo_completion()
        inoremap <expr><C-l>     neocomplcache#complete_common_string()

        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
          return neocomplcache#smart_close_popup() . "\<CR>"
          endfunction
          " <TAB>: completion.
          inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
          " <C-h>, <BS>: close popup and delete backword char.
          inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
          inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
          inoremap <expr><C-y>  neocomplcache#close_popup()
          inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
        \ }

        " Plugin key-mappings.
        inoremap <expr><C-g>     neocomplcache#undo_completion()
        inoremap <expr><C-l>     neocomplcache#complete_common_string()

        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
          return neocomplcache#smart_close_popup() . "\<CR>"
          endfunction
          " <TAB>: completion.
          inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
          " <C-h>, <BS>: close popup and delete backword char.
          inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
          inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
          inoremap <expr><C-y>  neocomplcache#close_popup()
          inoremap <expr><C-e>  neocomplcache#cancel_popup()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
