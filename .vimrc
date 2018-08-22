if isdirectory(expand("~/.vim/dein")) " sshrc
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

  if dein#load_state(expand('~/.vim/dein'))
    call dein#begin(expand('~/.vim/dein'))
    call dein#add('powerline/powerline', {'rtp': 'powerline/bindings/vim/'})
    call dein#add('haya14busa/incsearch.vim')
    call dein#add('osyo-manga/vim-over')
    call dein#add('Shougo/neocomplcache.vim')
    call dein#add('nathanaelkane/vim-indent-guides')
    call dein#add('derekwyatt/vim-scala')
    call dein#add('ekalinin/Dockerfile.vim')
    call dein#add('prabirshrestha/async.vim')
    call dein#add('prabirshrestha/vim-lsp')
  "  call dein#add('leftouterjoin/changed')
    call dein#end()
    call dein#save_state()
  endif
endif

filetype plugin indent on
syntax enable


"""""""""""
" general "
"""""""""""
colorscheme default
set t_Co=256
hi Visual term=reverse cterm=reverse guibg=Gray

set number

set timeout timeoutlen=10

set expandtab
set tabstop=2
set shiftwidth=2

"set cursorline
"set cursorcolumn
"highlight CursorColumn ctermbg=233

set ambiwidth=double

set whichwrap+=h,l,<,>,[,],b,s

set backspace=indent,eol,start

set wildmode=list,full

set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:&

set clipboard=unnamed

set ignorecase
"set incsearch
"set hlsearch | nohlsearch

set scrolloff=999

set ttyfast

set mouse=a

nnoremap x "_x

nnoremap ; :
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

autocmd InsertLeave * set nopaste
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


if isdirectory(expand("~/.vim/dein")) " sshrc
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
  "if !has('patch-8.0.1238')
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
  "endif


  """"""""""""
  " vim-over "
  """"""""""""
  nnoremap %s :OverCommandLine<CR>%s/\v/g<Left><Left>
  vnoremap %s :OverCommandLine<CR>s/\v/g<Left><Left>
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  """""""""""""""""
  " indent-guides "
  """""""""""""""""
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 0
  hi IndentGuidesOdd ctermbg=246
  hi IndentGuidesEven ctermbg=242
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  """""""""""""""""
  " neocomplcache "
  """""""""""""""""
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 1
  " Use underbar completion.
  let g:neocomplcache_enable_underbar_completion = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3

  " Plugin key-mappings.
  inoremap <expr><C-g> neocomplcache#undo_completion()

  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  """""""""""""""""""
  " language server "
  """""""""""""""""""
  if executable('clangd')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'clangd',
      \ 'cmd': {server_info->['clangd']},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'h'],
      \ })
  endif
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
endif
