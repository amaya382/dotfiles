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
" NeoBundle 'Shougo/unite.vim'
" NeoBundle 'Shougo/neomru.vim'
" NeoBundle 'scrooloose/nerdtree'
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

set number

""""""""""""""""""""""""""""""
" incsearch
""""""""""""""""""""""""""""""
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
"""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Unit
"""""""""""""""""""""""""""""""
"	" 入力モードで開始する
"	let g:unite_enable_start_insert=1
"	" バッファ一覧
"	noremap <C-P> :Unite buffer<CR>
"	" ファイル一覧
"	noremap <C-N> :Unite -buffer-name=file file<CR>
"	" 最近使ったファイルの一覧
"	noremap <C-Z> :Unite file_mru<CR>
"	" sourcesを「今開いているファイルのディレクトリ」とする
"	noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
"	" ウィンドウを分割して開く
"	au FileType unite nnoremap <silent> <buffer> <expr> <C-J>
"	" unite#do_action('split')
"	au FileType unite inoremap <silent> <buffer> <expr> <C-J>
"	" unite#do_action('split')
"	" ウィンドウを縦に分割して開く
"	au FileType unite nnoremap <silent> <buffer> <expr> <C-K>
"	" unite#do_action('vsplit')
"	au FileType unite inoremap <silent> <buffer> <expr> <C-K>
"	" unite#do_action('vsplit')
"	" ESCキーを2回押すと終了する
"	au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
"	au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
" """""""""""""""""""""""""""""

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
