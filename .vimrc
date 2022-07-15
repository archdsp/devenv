set encoding=utf-8
set fencs=utf-8

set nu
set autoindent
set ts=4
set shiftwidth=4
set softtabstop=4
set expandtab
au BufReadPost *
            \ if line ("'\"") > 0 && line ("'\"") <= line ("$") | 
            \ exe "norm g'\"" |
            \ endif

set list listchars=tab:>-,trail:·

set showmatch
set wmnu
set title
set incsearch
syntax on
filetype indent on
set showcmd
set cursorline
"set cursorcolumn

set virtualedit=all
