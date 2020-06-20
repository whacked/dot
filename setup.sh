# to bypass github ssl verify:
# export GIT_SSL_NO_VERIFY=true; bash setup.sh
# git config --global http.sslVerify false

_SCRIPT_DIRECTORY=$(dirname ${BASH_SOURCE[0]})

# NIX -------------------------------------------------------------------
if type nix-channel &> /dev/null; then
    export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
    mkdir -p $HOME/.config/nixpkgs
    if [ ! -e $HOME/.config/nixpkgs/home.nix ]; then
        ln -s $(realpath $_SCRIPT_DIRECTORY/home.nix) $HOME/.config/nixpkgs/home.nix
    fi
    export NIXPKGS_ALLOW_UNFREE=1
    if ! type home-manager &> /dev/null; then
        echo "installing home-manager..."
        nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        nix-shell '<home-manager>' -A install
    fi
    echo "prepare home-manager by running 'home-manager switch'"
fi
# DOTFILES --------------------------------------------------------------
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
[pull]
    rebase = true
[user]
    name = $USER
    email = $USER@fixme.example.com
[cola]
    spellcheck = false
GITCONFIG
fi

# ZSH -------------------------------------------------------------------
if [ `command -v zsh | wc -l` -ge 1 ]; then
    echo "setting up ZSH..."

    if [ ! -e ~/.oh-my-zsh ]; then
        echo "setting up oh-my-zsh..."

        # test for nix-supplied oh-my-zsh first
        _nix_oh_my_zsh_path=$(nix eval --raw nixpkgs.oh-my-zsh.outPath 2>/dev/null)
        if [ "x$_nix_oh_my_zsh_path" != "x" ] && [ -e $_nix_oh_my_zsh_path ]; then
            echo "using oh-my-zsh found from nix store: $_nix_oh_my_zsh_path"
            ln -sf $_nix_oh_my_zsh_path/share/oh-my-zsh $HOME/.oh-my-zsh
        else
            echo "cloning oh-my-zsh from github..."
            git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        fi

        nix eval --raw nixpkgs.oh-my-zsh.outPath 2>/dev/null
    fi

    if [ "x$USERCACHE" != "x" ] && [ -e $USERCACHE ]; then
        echo installing zsh-histdb into user cache...
        _zsh_histdb_source_path=$(nix-instantiate --eval -E 'with import <nixpkgs> {}; (callPackage (import ~/setup/nix/pkgs/shells/zsh-histdb/default.nix) {}).outPath' | tr -d '"')
        if [ "x$_zsh_histdb_source_path" != "x" ]; then
            echo found zsh-histdb in $_zsh_histdb_source_path
            ZSH_PLUGINS_DIR=$USERCACHE/zsh-plugins
            mkdir -p $ZSH_PLUGINS_DIR
            ln -sf $_zsh_histdb_source_path $ZSH_PLUGINS_DIR/zsh-histdb
        else
            echo "could not find location of zsh-histdb"
        fi
    else
        echo 'no usercache available'
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

