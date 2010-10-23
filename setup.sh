#ln -s ~/dot/.vimrc ~/.vimrc

echo "setting up vim-pathogen..."
ln -s ./.vim/vim-pathogen/autoload/pathogen.vim ./.vim/autoload/pathogen.vim

#ln -s ~/dot/.emacs ~/.emacs

cd .vim/autoload
ln -s /Users/natto/.vim/vim-pathogen/autoload/pathogen.vim pathogen.vim
cd -
