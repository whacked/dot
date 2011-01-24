filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

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

set nocompatible
filetype plugin indent on
let clj_highlight_builtins = 1
let clj_paren_rainbow = 1
let vimclojure#NailgunClient = "$HOME/.vim/vimclojure/ng"
let clj_want_gorilla = 1

set statusline=%F%m%r%h%w\ %{&ff}\ (%Y)\ (%04l,%04v)\ [ASC=\%03.3b,\ HEX=\%02.2B]\ [%p%%\ of\ %L]
set laststatus=2
set pastetoggle=<F2>
set cursorline



command! -nargs=* Wrap set wrap linebreak nolist

autocmd BufReadPre,FileReadPre    *.xoj setlocal bin
autocmd BufReadPost,FileReadPost  *.xoj  call gzip#read("gzip -S .xoj -dn")
autocmd BufWritePost,FileWritePost    *.xoj  call gzip#write("gzip -S .xoj")
autocmd FileAppendPre         *.xoj  call gzip#appre("gzip -S .xoj -dn")
autocmd FileAppendPost      *.xoj  call gzip#write("gzip -S .xoj")


