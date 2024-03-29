# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="crunch"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh


# Lines configured by zsh-newuser-install
# HISTFILE=~/.histfile
setopt appendhistory beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
### The following lines were added by compinstall
##zstyle :compinstall filename '/home/natto/.zshrc'
##
##autoload -Uz compinit
##compinit
### End of lines added by compinstall

setopt HIST_IGNORE_SPACE
setopt hist_ignore_dups extended_history HIST_SAVE_NO_DUPS


unsetopt correct_all

# http://stackoverflow.com/questions/10847255/how-to-make-zsh-forward-word-behaviour-same-as-in-bash-emacs
# Bash-like navigation
autoload -U select-word-style
select-word-style bash
# $HOME/.zsh/func was at the end of $FPATH, so the custom forward-word-match wasn't working
export FPATH=~/.zsh/func:$FPATH

# don't save failed commands to history
# http://superuser.com/a/902508
zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

trycount=1
while [ -e $HOME/dot/commonrc.$trycount ]; do
    source $HOME/dot/commonrc.$trycount
    trycount=$(($trycount+1))
done

ZSH_PLUGINS_DIR=$USERCACHE/zsh-plugins
if [ -e $ZSH_PLUGINS_DIR ]; then
    if [ -e $ZSH_PLUGINS_DIR/zsh-histdb ]; then
        source $ZSH_PLUGINS_DIR/zsh-histdb/sqlite-history.zsh
        autoload -Uz add-zsh-hook
    fi
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /nix/store/pcd6g56j7p68q2y4d753dzb8ckinafpm-minio-client-2022-03-09T02-08-36Z/bin/mc mc
