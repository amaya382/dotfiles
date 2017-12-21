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
"set incsearch
"set hlsearch | nohlsearch

set scrolloff=999

set ttyfast

set mouse=a

nnoremap ; :
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
