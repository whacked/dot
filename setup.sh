#!/usr/bin/env bash
# to bypass github ssl verify:
# export GIT_SSL_NO_VERIFY=true; bash setup.sh
# git config --global http.sslVerify false

_SCRIPT_DIRECTORY=$(dirname ${BASH_SOURCE[0]})

# NIX -------------------------------------------------------------------
if type nix-channel &> /dev/null; then
    export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
    mkdir -p $HOME/.config/home-manager
    if [ ! -e $HOME/.config/home-manager/home.nix ]; then
        ln -s $(realpath $_SCRIPT_DIRECTORY/home.nix) $HOME/.config/home-manager/home.nix
    fi
    export NIXPKGS_ALLOW_UNFREE=1
    if ! type home-manager &> /dev/null; then
        echo "installing home-manager..."
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        TMPDIR=/tmp nix-shell '<home-manager>' -A install
    fi
    echo "prepare home-manager by running 'home-manager switch'"
fi

# Dotfile symlinking is handled by home-manager (home.nix).


# ZOTERO ----------------------------------------------------------------
if [[ "$OSTYPE" == "linux"* ]] && type zotero &> /dev/null; then
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
    fi
fi  # /ZOTERO

if false; then
    # note if you need the gnus.el symlinked, modify home.nix
    # GNUS ------------------------------------------------------------------
    GNUS_DATA_DIR=$CLOUDSYNC/main/appdata/Gnus
    if [ ! -e $GNUS_DATA_DIR ]; then
        echo "creating Gnus directories at $GNUS_DATA_DIR"
        mkdir -p $GNUS_DATA_DIR/{News,Mail}
    fi
fi
