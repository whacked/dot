# to bypass github ssl verify:
# export GIT_SSL_NO_VERIFY=true; bash setup.sh
# git config --global http.sslVerify false

for DOTFILENAME in emacs.d vimrc vim tmux.conf bashrc Rprofile zshrc zsh boot.profile lein subversion; do
    echo [[ processing ]] $DOTFILENAME...
    DOTTARGET=~/.$DOTFILENAME
    if [ -e $DOTTARGET ] && [ ! -h $DOTTARGET ]; then
        BAK=~/`date +%F`.$DOTFILENAME
        echo -e "moving: .$DOTFILENAME\\t->\\t$BAK"
        mv $DOTTARGET $BAK
    fi

    if [ ! -e $DOTTARGET ]; then
        echo symlinking ~/dot/$DOTFILENAME to $DOTTARGET...
        ln -sf ~/dot/$DOTFILENAME $DOTTARGET
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
    git clone https://github.com/rupa/z.git ~/opt/z
fi

# ZSH -----------------------------------------------------------------
if [ `command -v zsh | wc -l` -ge 1 ]; then
    echo "setting up ZSH..."
    if [ ! -e ~/.oh-my-zsh ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    fi
else
    echo ... zsh not installed
fi

# submodule command sample
# git submodule add http://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree
echo "syncing git submodules..."
git submodule init && git submodule update

