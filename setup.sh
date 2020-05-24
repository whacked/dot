# to bypass github ssl verify:
# export GIT_SSL_NO_VERIFY=true; bash setup.sh
# git config --global http.sslVerify false

_SCRIPT_DIRECTORY=$(dirname ${BASH_SOURCE[0]})

for DOTFILENAME in emacs.d vimrc vim tmux.conf bashrc Rprofile zshrc zsh boot.profile lein subversion; do
    echo [[ processing ]] $DOTFILENAME...
    DOTTARGET=~/.$DOTFILENAME
    if [ -e $DOTTARGET ] && [ ! -h $DOTTARGET ]; then
        BAK=~/$DOTFILENAME.`date +%F`
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
    b = for-each-ref --sort=-committerdate refs/heads/ --format='%(authordate:short) %(color:red)%(objectname:short) %(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))'
[user]
    name = $USER
    email = $USER@fixme.example.com
[cola]
    spellcheck = false
GITCONFIG
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
pushd $_SCRIPT_DIRECTORY >/dev/null
    git submodule init && git submodule update
popd >/dev/null

_CHEMACS_DIRECTORY=$(realpath $_SCRIPT_DIRECTORY)/submodules/chemacs
if [ $(realpath ~/.emacs) == "$_CHEMACS_DIRECTORY/.emacs" ]; then
    echo chemacs is installed
else
    if [[ -e ~/.emacs && ! -L ~/.emacs ]]; then
        BAK=~/emacs.`date +%F`
        echo "~/.emacs already exists; backing up to $BAK"
        mv ~/.emacs $BAK
    fi
    pushd $_CHEMACS_DIRECTORY >/dev/null
        ./install.sh
    popd >/dev/null
fi

