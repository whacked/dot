#ln -s ~/dot/.emacs ~/.emacs

echo "setting up vim..."
#ln -s ~/dot/.vimrc ~/.vimrc
echo "setting up vim-pathogen..."
ln -s ./.vim/vim-pathogen/autoload/pathogen.vim ./.vim/autoload/pathogen.vim

cd .vim/autoload
ln -s /Users/natto/.vim/vim-pathogen/autoload/pathogen.vim pathogen.vim
cd -

# submodule command sample
# git submodule add http://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree
