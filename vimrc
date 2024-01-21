" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

" <vim-plug>
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'LnL7/vim-nix'
Plug 'Lokaltog/vim-powerline'
Plug 'PProvost/vim-ps1'
Plug 'TovarishFin/vim-solidity'
Plug 'altercation/vim-colors-solarized'
Plug 'chrisbra/matchit'
Plug 'docunext/closetag.vim'
Plug 'editorconfig/vim-editorconfig'
Plug 'elixir-editors/vim-elixir'
Plug 'fatih/vim-go'
Plug 'gkz/vim-ls'
Plug 'google/vim-jsonnet'
Plug 'hashivim/vim-terraform'
Plug 'hashivim/vim-vagrant'
Plug 'honza/vim-snippets'
Plug 'hylang/vim-hy'
Plug 'jamessan/vim-gnupg'
Plug 'jceb/vim-orgmode'
Plug 'jdonaldson/vaxe'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'jremmen/vim-ripgrep'
Plug 'kien/ctrlp.vim'
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'sjl/tslime2.vim'
Plug 'tmatilai/gitolite.vim'
Plug 'tpope/timl'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/AutoClose'
Plug 'vmchale/just-vim'
Plug 'wincent/Command-T'
Plug 'yegappan/mru'

call plug#end()
" </vim-plug>


let g:AutoCloseExpandEnterOn = ""

" most recently visited files
let MRU_Max_Entries = 200

filetype off
filetype plugin indent on

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
set hlsearch
set ic
set foldlevel=100
set noincsearch

autocmd Filetype ruby setlocal ts=2 sts=2 sw=2

let g:syntastic_mode_map = { 'mode': 'passive' }
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

set tags=tags;

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

" FIXME: old tmux interop (kikijump version is gone)
" source ~/.vim/vim-addons/github-kikijump-tslime.vim/tslime.vim
" function! To_Tmux()
"   let b:text = input("tmux:", "", "custom,")
"   call Send_to_Tmux(b:text . "\\r")
" endfunction
" 
" " cmap tt :call To_Tmux()<CR>


" CtrlP options
set wildignore+=*.py\\,cover
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|venv|venv3)$',
  \ 'file':  '\v(swp)$',
  \ }
let g:ctrlp_working_path_mode = 'ra'

" NERDTree
let NERDTreeDirArrows=0
let NERDTreeTabsOpen=1
let NERDTreeQuitOnOpen=0

inoremap {{ {{  }}<Esc>hhi

