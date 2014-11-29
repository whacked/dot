" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

fun SetupVAM()
  let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
  exec 'set rtp+='.vam_install_path.'/vim-addon-manager'
  " let g:vim_addon_manager = { your config here see "commented version" example and help
  if !isdirectory(vam_install_path.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(vam_install_path, 1).'/vim-addon-manager'
  endif
  call vam#ActivateAddons([
              \   'vim-snippets'
              \ , 'github:jdonaldson/vaxe'
              \ , 'git-time-lapse'
              \ , 'vim-ipython'
              \ , 'github:altercation/vim-colors-solarized'
              \ , 'github:Lokaltog/vim-powerline'
              \ , 'csv'
              \ , 'vim-coffee-script'
              \ , 'github:kien/ctrlp.vim'
              \ ], {'auto_install' : 0})

endfun
call SetupVAM()

filetype off
"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/vundle'

" My Bundles here:
"
"" " original repos on github
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'docunext/closetag.vim'
Plugin 'tmatilai/gitolite.vim'
Plugin 'kikijump/tslime.vim'
Plugin 'wincent/Command-T'
Plugin 'majutsushi/tagbar'
Plugin 'python-rope/ropevim'

"" " vim-scripts repos
Plugin 'matchit.zip'
Plugin 'AutoClose'
Plugin 'occur.vim'
Plugin 'gnupg.vim'
"" Bundle 'L9'
"" Bundle 'FuzzyFinder'
"" " non github repos
"" Bundle 'git://git.wincent.com/command-t.git'
Plugin 'fatih/vim-go'

call vundle#end()
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

autocmd Filetype ruby setlocal ts=2 sts=2 sw=2

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

source ~/.vim/bundle/tslime.vim/tslime.vim
function! To_Tmux()
  let b:text = input("tmux:", "", "custom,")
  call Send_to_Tmux(b:text . "\\r")
endfunction

" cmap tt :call To_Tmux()<CR>


" CtrlP options
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|venv|venv3)$',
  \ 'file':  '\v(swp)$',
  \ }
let g:ctrlp_working_path_mode = 'ra'

" NERDTree
let NERDTreeTabsOpen=1
let NERDTreeQuitOnOpen=0
