#ln -s ~/dot/.emacs ~/.emacs

echo "setting up vim..."
ln -s ~/dot/.vimrc ~/.vimrc
ln -s ~/dot/.vim ~/.vim
echo "setting up vim-pathogen..."
ln -s ~/dot/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

# submodule command sample
# git submodule add http://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree
