# to bypass github ssl verify:
# export GIT_SSL_NO_VERIFY=true; bash setup.sh
# git config --global http.sslVerify false

for DOTFILE in .emacs .emacs.d .vimrc .vim .tmux.conf .bashrc .Rprofile .zshrc; do
    echo processing $DOTFILE...
    if [ -e ~/$DOTFILE ] && [ ! -h ~/$DOTFILE ]; then
        BAK=~/`date +%F`$DOTFILE
        echo -e "moving: $DOTFILE\\t->\\t$BAK"
        mv ~/.emacs $BAK
    fi

    if [ ! -e ~/$DOTFILE ]; then
        ln -s ~/dot/$DOTFILE ~/$DOTFILE
    fi
done

# GIT -------------------------------------------------------------------
if [ ! -e ~/.gitconfig ]; then
    echo "setting up gitconfig..."
    cat > ~/.gitconfig <<GITCONFIG
[core]
	autocrlf = false
	safecrlf = false
[alias]
    P = push
    a = add
    st = status -s
    ci = commit
    df = diff --color --color-words --abbrev
    l = log --graph --pretty=oneline --abbrev-commit --decorate
    lg   = log --pretty=oneline --abbrev-commit --graph --decorate --date=relative
    lgt  = log --graph --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
    lgtt = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
GITCONFIG
fi

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
if [ ! -e ~/.emacs ]; then
    echo "setting up emacs..."
    :
fi

# VIM ----------------------------------------------------------------
if [ ! -e ~/.vimrc ]; then
    echo "setting up vim..."
    echo "... setting up vim-pathogen"
    ln -s ~/dot/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
fi

# TMUX ----------------------------------------------------------------
if [ ! -e ~/.tmux.conf ]; then
    echo "setting up tmux..."
    :
fi

# R -------------------------------------------------------------------
if [ ! -e ~/.Rprofile ]; then
    echo "setting up R..."
    :
fi

# ZSH -----------------------------------------------------------------
if [ `command -v zsh | wc -l` -ge 1 ]; then
    echo "setting up ZSH..."
    if [ ! -e ~/.oh-my-zsh ]; then
        git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    fi
else
    echo ... zsh not installed
fi

# LEIN ----------------------------------------------------------------
if [ `command -v lein | wc -l` -ge 1 ]; then
    echo "setting up leiningen"
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

VUNDLEDIR=~/dot/.vim/bundle/vundle/
IGNOREFILE=$VUNDLEDIR/.gitignore
if [ -e $VUNDLEDIR ]; then
    if [ -e $IGNOREFILE ]; then
        echo "... vundle ignore file exists already"
    else
        echo "generating hacky gitignore for vundle, because it generates tags..."
        echo '.netrwhist' >> $IGNOREFILE
        echo '.gitignore' >> $IGNOREFILE
        echo 'doc/tags' >> $IGNOREFILE
    fi
else
    echo 'run setup again after BundleInstall to add the vundle ignore file'
fi

