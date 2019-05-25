if isdirectory(expand("~/.vim/dein")) " sshrc
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

  if dein#load_state(expand('~/.vim/dein'))
    call dein#begin(expand('~/.vim/dein'))
    call dein#add('haya14busa/incsearch.vim')
    call dein#add('osyo-manga/vim-over')
    call dein#add('Shougo/neocomplcache.vim')
    call dein#add('nathanaelkane/vim-indent-guides')
    call dein#add('derekwyatt/vim-scala')
    call dein#add('ekalinin/Dockerfile.vim')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')
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
hi Visual cterm=reverse ctermbg=Black gui=none
hi MatchParen ctermbg=1 gui=none
set background=dark

set number

if !has("mac")
  set timeout timeoutlen=10
endif

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

if has("mac")
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

set ignorecase
set smartcase
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
  """""""""""
  " airline "
  """""""""""
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  let g:airline_theme = 'dracula'
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  """""""""""""
  " incsearch "
  """""""""""""
  "if !has('patch-8.0.1238')
    map /  <Plug>(incsearch-forward)
  "endif
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  """"""""""""
  " vim-over "
  """"""""""""
  nnoremap ? :OverCommandLine<CR>%s/\v/g<Left><Left>
  vnoremap ? :OverCommandLine<CR>s/\v/g<Left><Left>
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  """""""""""""""""
  " indent-guides "
  """""""""""""""""
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 0
  hi IndentGuidesOdd ctermbg=black
  hi IndentGuidesEven ctermbg=darkgray
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
endif
