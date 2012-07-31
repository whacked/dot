# EMACS ----------------------------------------------------------------
echo "setting up emacs..."
if [ ! -e ~/.emacs ]; then
    ln -s ~/dot/.emacs ~/.emacs
    ln -s ~/dot/.emacs.d ~/.emacs.d
fi

# VIM ----------------------------------------------------------------
echo "setting up vim..."
if [ ! -e ~/.vimrc ]; then
    ln -s ~/dot/.vimrc ~/.vimrc
    ln -s ~/dot/.vim ~/.vim
    echo "setting up vim-pathogen..."
    ln -s ~/dot/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
fi

# TMUX ----------------------------------------------------------------
echo "setting up tmux..."
if [ ! -e ~/.tmux.conf ]; then
    ln -s ~/dot/.tmux.conf ~/.tmux.conf
fi

echo "setting up leiningen"
if [ -e ~/.lein ]; then
    if [ -e ~/.lein/init.clj ]; then
        echo ".lein/init.clj exists..."
    else
        ln -s ~/dot/init.clj ~/.lein/init.clj
    fi
else
    echo "lein not installed"
fi

# submodule command sample
# git submodule add http://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree

echo "syncing git submodules..."
git submodule init
git submodule update

echo "hacky gitignore for vundle, because it generates tags..."
IGNOREFILE=~/dot/.vim/bundle/vundle/.gitignore
if [ -e $IGNOREFILE ]; then
    echo "ignore file exists already"
else
    echo "generating..."
    echo '.netrwhist' >> $IGNOREFILE
    echo '.gitignore' >> $IGNOREFILE
    echo 'doc/tags' >> $IGNOREFILE
fi

ln -s ~/dot/.Rprofile ~/.Rprofile
