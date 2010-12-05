# EMACS ----------------------------------------------------------------
echo "setting up emacs..."
if [ ! -e ~/.emacs ]; then
    ln -s ~/dot/.emacs ~/.emacs
    ln -s ~/dot/.emacs.d ~/.emacs.d
fi

# git submodule add git://github.com/chrisdone/zencoding.git .emacs.d/bundle/zencoding
# git submodule add git://repo.or.cz/org-mode.git .emacs.d/bundle/org-mode

# VIM ----------------------------------------------------------------
echo "setting up vim..."
if [ ! -e ~/.vimrc ]; then
    ln -s ~/dot/.vimrc ~/.vimrc
    ln -s ~/dot/.vim ~/.vim
    echo "setting up vim-pathogen..."
    ln -s ~/dot/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
fi

# submodule command sample
# git submodule add http://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree

echo "syncing git submodules..."
git submodule init
git submodule update

