#ln -s ~/dot/.emacs ~/.emacs

echo "setting up vim..."
ln -s ~/dot/.vimrc ~/.vimrc
if [ ! -e ~/dot/.vim ]; then
    ln -s ~/dot/.vim ~/.vim
fi
echo "setting up vim-pathogen..."
ln -s ~/dot/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

# submodule command sample
# git submodule add http://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree
