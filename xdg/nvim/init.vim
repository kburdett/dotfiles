" =========
"  Plugins
" =========
call plug#begin('$XDG_CACHE_HOME/nvim/plugged')

Plug 'ekalinin/Dockerfile.vim' 
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'elzr/vim-json'
Plug 'kburdett/vim-nuuid'
Plug 'PProvost/vim-ps1'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'stephpy/vim-yaml'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/nginx.vim'
Plug 'w0rp/ale'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'chrisbra/csv.vim' 
Plug 'nanotech/jellybeans.vim'
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

" matchit!  
runtime! macros/matchit.vim



" =========
"  Options
" =========

" editing
set clipboard+=unnamedplus   "yank to system clipboard by default
set fileformats-=mac
set mouse=a

" display
set showmatch
set number
set showcmd
set scrolloff=2
set sidescrolloff=5

" indentation
set shiftround
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" searching
set ignorecase
set smartcase

" swap and backup
set noswapfile

" error bells
set noerrorbells
set visualbell

" misc
set ruler
set hidden
set ttimeout
set ttimeoutlen=100 



" ==============
"  Key Bindings
" ==============
nnoremap <silent> <Leader>/ :nohlsearch<CR>
nnoremap <Leader>, mqA,<Esc>`q
nnoremap <Leader>; mqA;<Esc>`q

" map entire file text objects
vnoremap ae :<C-U>silent! normal! ggVG<CR>
onoremap ae :<C-U>normal! ggVG<CR>

" kill the command ex mode key
nnoremap Q <Nop>

" switch between window splits
nnoremap <silent> <C-K> :wincmd k<CR>
nnoremap <silent> <C-J> :wincmd j<CR>
nnoremap <silent> <C-H> :wincmd h<CR>
nnoremap <silent> <C-L> :wincmd l<CR>

"Buffergator
nnoremap <silent> <C-B> :BuffergatorToggle<CR>



" =================
"  Custom Commands
" =================
command! Vimrc edit $MYVIMRC
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

