set nocompatible
filetype off
"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
"" " original repos on github
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-fugitive'
Bundle 'docunext/closetag.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Lokaltog/vim-powerline'
Bundle 'tmatilai/gitolite.vim'
Bundle 'kikijump/tslime.vim'
Bundle 'wincent/Command-T'
Bundle 'majutsushi/tagbar'
"" " vim-scripts repos
Bundle 'matchit.zip'
Bundle 'AutoClose'
Bundle 'occur.vim'
Bundle 'snipMate'
Bundle 'gnupg.vim'
"" Bundle 'L9'
"" Bundle 'FuzzyFinder'
"" " non github repos
"" Bundle 'git://git.wincent.com/command-t.git'

let g:Powerline_symbols = 'fancy'

syntax on
set number " to turn off use :set number! or :set nu!
set expandtab
set tabstop=4
set shiftwidth=4
set cindent
set autoindent
let g:slimv_lisp = '"java cp $HOME/dev/lisp/clojure/clojure.jar clojure.lang.Repl"'
set nowrap
set ic

filetype plugin indent on
let clj_highlight_builtins = 1
let clj_paren_rainbow = 1
let vimclojure#NailgunClient = "$HOME/.vim/vimclojure/ng"
let clj_want_gorilla = 1

set statusline=%F%m%r%h%w\ %{&ff}\ (%Y)\ (%04l,%04v)\ [ASC=\%03.3b,\ HEX=\%02.2B]\ [%p%%\ of\ %L]
set laststatus=2
set pastetoggle=<F2>
set cursorline
" set cwd to that of the current active buffer
set autochdir



command! -nargs=* Wrap set wrap linebreak nolist

autocmd BufReadPre,FileReadPre    *.xoj setlocal bin
autocmd BufReadPost,FileReadPost  *.xoj  call gzip#read("gzip -S .xoj -dn")
autocmd BufWritePost,FileWritePost    *.xoj  call gzip#write("gzip -S .xoj")
autocmd FileAppendPre         *.xoj  call gzip#appre("gzip -S .xoj -dn")
autocmd FileAppendPost      *.xoj  call gzip#write("gzip -S .xoj")


set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
colorscheme solarized

source ~/.vim/bundle/tslime.vim/tslime.vim
function! To_Tmux()
  let b:text = input("tmux:", "", "custom,")
  call Send_to_Tmux(b:text . "\\r")
endfunction

" cmap tt :call To_Tmux()<CR>
