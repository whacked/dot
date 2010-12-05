export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
PS1="\[\033[0m\][\[\033[32m\]\A\[\033[0m\]] \[\033[1;33m\]\u\[\033[0m\]@\h \[\033[36m\][\w]:\[\033[0m\] "
export PATH=$PATH:/Library/Frameworks/Python.framework/Versions/Current/bin:/sw/bin:/sw/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/texbin:/usr/X11/bin:/usr/local/git/bin:/usr/X11R6/bin

# for erlang nitrogen
export ERL_LIBS=~/dev/erlang/nitrogen-read-only

export CLOJURE_EXT=~/dev/lisp/clojure
export PATH=$PATH:~/dev/lisp/clojure/clojure-contrib/launchers/bash:~/.cljr/bin

# MacPorts Installer addition on 2009-10-18_at_14:51:11: adding an appropriate PATH variable for use with MacPorts.
#export PATH=$PATH:/opt/local/bin:/opt/local/sbin:~/dev/android/android-sdk-mac_x86-1.6_r1/tools
# Finished adapting your PATH environment variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:~/dev/android/android-sdk-mac_x86-1.6_r1/tools:$PATH
export EDITOR=vim

export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/spidermonkey/lib

export HISTIGNORE="[ \t]*"
