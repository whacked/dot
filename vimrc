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
              \ , 'github:scrooloose/nerdtree'
              \ , 'github:jistr/vim-nerdtree-tabs'
              \ , 'github:scrooloose/syntastic'
              \ , 'github:scrooloose/nerdcommenter'
              \ , 'github:tpope/vim-fugitive'
              \ , 'github:tpope/vim-unimpaired'
              \ , 'github:tpope/vim-speeddating'
              \ , 'github:docunext/closetag.vim'
              \ , 'github:tmatilai/gitolite.vim'
              \ , 'github:kikijump/tslime.vim'
              \ , 'github:wincent/Command-T'
              \ , 'github:majutsushi/tagbar'
              \ , 'github:python-rope/ropevim'
              \ , 'matchit.zip'
              \ , 'github:vim-scripts/AutoClose'
              \ , 'occur'
              \ , 'github:jamessan/vim-gnupg'
              \ , 'github:fatih/vim-go'
              \ , 'github:Glench/Vim-Jinja2-Syntax'
              \ , 'vim-orgmode'
              \ , 'github:hylang/vim-hy'
              \ , 'github:airblade/vim-gitgutter'
              \ ], {'auto_install' : 0})

endfun
call SetupVAM()

" ref https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

let g:AutoCloseExpandEnterOn = ""

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

source ~/.vim/vim-addons/github-kikijump-tslime.vim/tslime.vim
function! To_Tmux()
  let b:text = input("tmux:", "", "custom,")
  call Send_to_Tmux(b:text . "\\r")
endfunction

" cmap tt :call To_Tmux()<CR>


" CtrlP options
set wildignore+=*.py\\,cover
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|venv|venv3)$',
  \ 'file':  '\v(swp)$',
  \ }
let g:ctrlp_working_path_mode = 'ra'

" NERDTree
let NERDTreeTabsOpen=1
let NERDTreeQuitOnOpen=0

inoremap {{ {{  }}<Esc>hhi
