# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# to prevent nix bash annoyance
shopt -s direxpand


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Unlimited size for the history file
export HISTSIZE=-1
export HISTFILESIZE=-1

# append to the history file, don't overwrite it
shopt -s histappend

# Immediately append to the history file, not just when a session ends
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# ====================================================================================================
### CUSTOM EDIT
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
PS1="\[\033[0m\][\[\033[32m\]\A\[\033[0m\]] \[\033[1;33m\]\u\[\033[0m\]@\h \[\033[36m\][\w]:\[\033[0m\] "

# to renable in cli: set +C
set -o noclobber # prevent > FILE from overwriting existing

export HISTIGNORE="[ ]*"
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%F %T "
# make bash save history across simultaneous terminal sessions
export PROMPT_COMMAND='history -a'

if [ -f ~/$(hostname).bashrc ]; then . ~/$(hostname).bashrc; fi

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

trycount=1
while [ -e $HOME/dot/commonrc.$trycount ]; do
    source $HOME/dot/commonrc.$trycount
    trycount=$(($trycount+1))
done

complete -C /nix/store/8wh2pzcz6c43djzvrpn7hvg075d9k8rz-minio-client-2023-05-04T18-10-16Z/bin/mc mc

