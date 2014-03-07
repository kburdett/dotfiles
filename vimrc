execute pathogen#infect()
execute pathogen#helptags()

if has("gui_running")
    colorscheme twilight
endif

" set the basics
let mapleader=","
set nocompatible
set number
set showmatch
set laststatus=2
set showbreak=↪
set clipboard=unnamed	"yank to system clipboard by default
set tabstop=4
set shiftwidth=4
set expandtab
set hidden
set ignorecase
set smartcase
" disable swap and backup
set nobackup
set noswapfile
" disable sound on errors
set noerrorbells
set visualbell

" Key rebindings
nmap <silent> ,/ :nohlsearch<CR>
nnoremap <F5> :GundoToggle<CR>
nnoremap Q gq
" rebind Alt-movement keys to move a block of text
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" switch between window splits
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

" status line
set statusline=
set statusline=%t       "tail of the filename
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%{fugitive#statusline()}
set statusline+=\ %c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

command! Vimrc edit $MYVIMRC
command! Gvimrc edit $MYGVIMRC
command! Bashp edit ~/.bash_profile

" OS dependent items
if has("win32") || has("win16")
    " Consolas FTW!
    set gfn=Consolas

    command! PrettyXml % !xmllint.exe % --format
else
    " Not windows... assume Mac OSX
    set gfn=Monaco

    command! PrettyXml % !xmllint % --format
endif

" auto source .vimrc on save
augroup AutoReloadVimRC
    autocmd!
    autocmd BufWritePost $MYVIMRC so $MYVIMRC
augroup END
