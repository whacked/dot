# EMACS ----------------------------------------------------------------
echo "setting up emacs..."
ln -s ~/dot/.emacs ~/.emacs
ln -s ~/dot/.emacs.d ~/.emacs.d

# git submodule add git://github.com/chrisdone/zencoding.git .emacs.d/bundle/zencoding


# VIM ----------------------------------------------------------------
echo "setting up vim..."
ln -s ~/dot/.vimrc ~/.vimrc
if [ ! -e ~/dot/.vim ]; then
    ln -s ~/dot/.vim ~/.vim
fi
echo "setting up vim-pathogen..."
ln -s ~/dot/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

# submodule command sample
# git submodule add http://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree

echo "syncing git submodules..."
git submodule init
git submodule update

