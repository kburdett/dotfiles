" ========
"  Leader
" ========
let mapleader = ' '


" =========
"  Plugins
" =========
call plug#begin('~/.vim/plugged')

" core
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'

" UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'jeetsukumaran/vim-buffergator'

" LSP-ish
Plug 'w0rp/ale'

" Filetypes
Plug 'ekalinin/Dockerfile.vim'
Plug 'elzr/vim-json'
Plug 'PProvost/vim-ps1'
Plug 'stephpy/vim-yaml'
Plug 'vim-scripts/nginx.vim'
Plug 'chrisbra/csv.vim'

" Colorscheme
Plug 'joshdick/onedark.vim'

call plug#end()

" airline
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" NERD Tree
map <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
" start NERD if a directory is opened
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close NERD if it's the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

if has('autocmd')
    filetype plugin indent on
endif
if has('syntax')
    syntax enable
endif

" matchit!
runtime! macros/matchit.vim



" =========
"  Options
" =========

" editing
set backspace=indent,eol,start
set clipboard=unnamed   "yank to system clipboard by default
set nrformats-=octal
set fileformats-=mac
set autoread
set mouse=a

" display
set showmatch
set number
set showcmd
set scrolloff=2
set sidescrolloff=5

" indentation
set autoindent
set shiftround
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" searching
set incsearch
set ignorecase
set smartcase
set hlsearch

" swap and backup
set nobackup
set noswapfile

" error bells
set noerrorbells
set visualbell

" misc
set wildmenu
set ruler
set history=1000
set tabpagemax=50
set nocompatible
set hidden
set viminfo^=!
set ttimeout
set ttimeoutlen=100

if !has('win32') && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
    let &listchars="tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
else
    set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+
endif



" ==============
"  Key Bindings
" ==============
nnoremap <silent> <Leader>/ :nohlsearch<CR>


" quick line endings
nnoremap <Leader>, mqA,<Esc>`q
nnoremap <Leader>; mqA;<Esc>`q

" add empty lines before and after cursor line
nnoremap <Leader>O <Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>
nnoremap <Leader>o <Cmd>call append(line('.')    , repeat([''], v:count1))<CR>

" kill the command ex mode key
nnoremap Q <Nop>

" switch between window splits
nnoremap <silent> <C-K> :wincmd k<CR>
nnoremap <silent> <C-J> :wincmd j<CR>
nnoremap <silent> <C-H> :wincmd h<CR>
nnoremap <silent> <C-L> :wincmd l<CR>

" Buffergator
nnoremap <silent> <C-B> :BuffergatorToggle<CR>

" reformat code
nnoremap <silent> <Leader>r ggVGgq



" =================
"  Custom Commands
" =================
command! Vimrc edit $MYVIMRC
command! Gvimrc edit $MYGVIMRC
command! PrettyXml % !xmllint % --format
command! PrettyJson % !jq '.'
command! MinJson % !jq '.' -c

function! s:PasteAsJson()
    put
    set ft=json
    %!jq '.'
endfunction
command! PJ call s:PasteAsJson()

" auto source .vimrc on save
augroup AutoReloadVimRC
    autocmd!
    autocmd BufWritePost $MYVIMRC so $MYVIMRC
    autocmd BufWritePost $MYGVIMRC so $MYGVIMRC
augroup END



" =============
"  Colorscheme
" =============

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=16
endif
if (has("termguicolors"))
    set termguicolors
endif
colorscheme onedark
