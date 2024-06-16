#!/usr/bin/env bash
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
        TMPDIR=/tmp nix-shell '<home-manager>' -A install
    fi
    echo "prepare home-manager by running 'home-manager switch'"
fi

# DOTFILES --------------------------------------------------------------
for DOTFILENAME in emacs.d emacs.d/gnus.el gitconfig vimrc vim tmux.conf bashrc Rprofile zshrc zsh boot.profile lein subversion; do
    echo [[ processing ]] $DOTFILENAME...

    case $DOTFILENAME in
        *gnus.el)
            DOTTARGET=~/.gnus.el
            ;;

        *)
            DOTTARGET=~/.$DOTFILENAME
            ;;
    esac

    if [ -e $DOTTARGET ] && [ ! -h $DOTTARGET ]; then
        BAK=~/$DOTFILENAME.`date +%F`
        echo -e "moving: .$DOTFILENAME\\t->\\t$BAK"
        mv $DOTTARGET $BAK
    fi

    if [ ! -e $DOTTARGET ]; then
        DOTSOURCE=~/dot/$DOTFILENAME
        echo symlinking $DOTSOURCE to $DOTTARGET...
        if [ ! -e $DOTSOURCE ]; then
            echo "WARN: $DOTSOURCE does not exist; assuming it should be a directory"
            mkdir $DOTSOURCE
        fi
        ln -sf $DOTSOURCE $DOTTARGET
    fi
done

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

# ZOTERO ----------------------------------------------------------------
# start zotero once to generate the profile directory
ZOTEROHOME=$HOME/.zotero/zotero
ZOTEROINI=$ZOTEROHOME/profiles.ini
ZOTERO_DATA_DIR=$CLOUDSYNC/main/appdata/Zotero

# modify user.js in the profile directory to override
# the dataDir setting to a custom storage directory.
# Zotero will read the setting from user.js and write
# it back into prefs.js
ZOTERO_FAILED_TESTS=()
if [ ! -e $ZOTEROINI ]; then
    ZOTERO_FAILED_TESTS+=(ini-not-exist)
else
    ZOTERO_PROFILE0=$(crudini --get $ZOTEROHOME/profiles.ini Profile0 Path)
    if [ "x$ZOTERO_PROFILE0" != "x" ]; then
        ZOTERO_PROFILEDIR=$(crudini --get $ZOTEROHOME/profiles.ini Profile0 path)
    fi
fi
[ "x$ZOTERO_PROFILEDIR" == "x" ] && ZOTERO_FAILED_TESTS+=(no-profile-dir)
[ ! -e $ZOTEROHOME/$ZOTERO_PROFILEDIR ] && ZOTERO_FAILED_TESTS+=(profile-dir-not-exist)
[ ! -e $ZOTERO_DATA_DIR ] && ZOTERO_FAILED_TESTS+=(data-dir-not-exist)
if [ ${#ZOTERO_FAILED_TESTS[@]} -gt 0 ]; then
    echo "- ZOTERO failed tests: ${ZOTERO_FAILED_TESTS[@]}"
else
    echo "UPDATING Zotero profile settings at $ZOTEROHOME/$ZOTERO_PROFILEDIR/user.js"
    echo 'user_pref("extensions.zotero.dataDir", "'$ZOTERO_DATA_DIR'");' | tee $ZOTEROHOME/$ZOTERO_PROFILEDIR/user.js
# GNUS ------------------------------------------------------------------
GNUS_DATA_DIR=$CLOUDSYNC/main/appdata/Gnus
if [ ! -e $GNUS_DATA_DIR ]; then
    echo "creating Gnus directories at $GNUS_DATA_DIR"
    mkdir -p $GNUS_DATA_DIR/{News,Mail}
fi
