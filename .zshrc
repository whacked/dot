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

# Customize to your needs...
TERM="xterm-256color"
source ~/opt/z/z.sh
PATH=$PATH:~/opt/leiningen:~/.config/thinkpad:/opt:~/.cabal/bin

# Lines configured by zsh-newuser-install
# HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
### The following lines were added by compinstall
##zstyle :compinstall filename '/home/natto/.zshrc'
##
##autoload -Uz compinit
##compinit
### End of lines added by compinstall
##
### zgitinit and prompt_wunjo_setup must be somewhere in your $fpath, see README for more.
##
##setopt promptsubst
##
### Load the prompt theme system
##autoload -U promptinit
##promptinit
##
### Use the wunjo prompt theme
##prompt wunjo
##

alias open='gnome-open 2>/dev/null'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
# http://askubuntu.com/questions/110922/climb-up-the-directory-tree-faster
# Go up directory tree X number of directories
function up() {
        COUNTER="$@";
    # default $COUNTER to 1 if it isn't already set
if [[ -z $COUNTER ]]; then
    COUNTER=1
fi
# make sure $COUNTER is a number
if [ $COUNTER -eq $COUNTER 2> /dev/null ]; then
    nwd=`pwd` # Set new working directory (nwd) to current directory
    # Loop $nwd up directory tree one at a time
    until [[ $COUNTER -lt 1 ]]; do
        nwd=`dirname $nwd`
        let COUNTER-=1
    done
    cd $nwd # change directories to the new working directory
else
    # print usage and return error
    echo "usage: up [NUMBER]"
    return 1
fi
}

setopt HIST_IGNORE_SPACE

alias gits='git status -s'

