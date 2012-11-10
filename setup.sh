for DOTFILE in .emacs .vim .tmux.conf .bashrc .Rprofile .zshrc; do
    if [ -e ~/$DOTFILE ] && [ ! -h ~/$DOTFILE ]; then
        BAK=~/`date +%F`$DOTFILE
        echo -e "moving: $DOTFILE\\t->\\t$BAK"
        mv ~/.emacs $BAK
    fi
done

# opt directory
if [ ! -e ~/opt ]; then
    echo adding opt directory...
    mkdir ~/opt
fi

# rupa's z---------------------------------------------------------------
if [ ! -e ~/opt/z ]; then
    echo "adding rupa's z..."
    git clone git://github.com/rupa/z.git ~/opt/z
fi

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
    echo "... setting up vim-pathogen"
    ln -s ~/dot/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
fi

# TMUX ----------------------------------------------------------------
echo "setting up tmux..."
if [ ! -e ~/.tmux.conf ]; then
    ln -s ~/dot/.tmux.conf ~/.tmux.conf
fi

# R -------------------------------------------------------------------
echo "setting up R..."
if [ ! -e ~/.Rprofile ]; then
    ln -s ~/dot/.Rprofile ~/.Rprofile
fi

# ZSH -----------------------------------------------------------------
echo "setting up ZSH..."
if [ `command -v zsh | wc -l` -ge 1 ]; then
    if [ ! -e ~/.zshrc ]; then
        ln -s ~/dot/.zshrc ~/.zshrc
    fi
    if [ ! -e ~/.oh-my-zsh ]; then
        git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    fi
else
    echo zsh not installed
fi

# LEIN ----------------------------------------------------------------
echo "setting up leiningen"
if [ `command -v lein | wc -l` -ge 1 ]; then
    if [ ! -e ~/.lein ]; then
        mkdir ~/.lein
    fi
    if [ -e ~/.lein/init.clj ]; then
        echo "... .lein/init.clj exists"
    else
        ln -s ~/dot/init.clj ~/.lein/init.clj
    fi
else
    echo ... leiningen not installed
fi

# submodule command sample
# git submodule add http://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree
echo "syncing git submodules..."
git submodule init
git submodule update

IGNOREFILE=~/dot/.vim/bundle/vundle/.gitignore
if [ -e $IGNOREFILE ]; then
    echo "... vundle ignore file exists already"
else
    echo "generating hacky gitignore for vundle, because it generates tags..."
    echo '.netrwhist' >> $IGNOREFILE
    echo '.gitignore' >> $IGNOREFILE
    echo 'doc/tags' >> $IGNOREFILE
fi

