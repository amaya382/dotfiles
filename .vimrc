" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc'
NeoBundle 'derekwyatt/vim-scala'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax highlight
syntax on

" 行番号 
set number

" 行列強調
set cursorline
set cursorcolumn
highlight CursorColumn cterm=none ctermbg=black ctermfg=white

" 文字幅
set ambiwidth=double

" 行間移動
set whichwrap+=h,l,<,>,[,],b,s

"バックスペースキーで行頭を削除する
set backspace=indent,eol,start

" コマンド補完
set wildmode=list,full

" 不可視文字
set list
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮

" clipboard
set clipboard=unnamed

"大文字小文字を区別しない
set ignorecase

"カーソルを常に画面の中央に表示させる
set scrolloff=999

"ターミナル接続を高速にする
set ttyfast

"ターミナルで256色表示を使う
set t_Co=256

"矢印キーでは表示行単位で行移動する
nmap <UP> gk
nmap <DOWN> gj
vmap <UP> gk
vmap <DOWN> gj

"""""""""""""
""powerline""
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" incsearch
""""""""""""""""""""""""""""""
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
"""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" neocomplcache
""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""
" Unite / VimFiler
"""""""""""""""""""""""""""""
"autocmd VimEnter * VimFiler -split -simple -winwidth=30 -no-quit
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default=0
map <C-e> :VimFiler -split -simple -winwidth=35 -no-quit<CR>
map <C-a> :UniteBookmarkAdd<CR>
map <C-z> :Unite bookmark<CR>
call unite#custom#default_action('directory' , 'vimfiler')
"""""""""""""""""""""""""""""


