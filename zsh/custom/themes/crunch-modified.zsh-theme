# from https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/crunch.zsh-theme
CRUNCH_BRACKET_COLOR="%{$fg[white]%}"
CRUNCH_TIME_COLOR="%{$fg[yellow]%}"
CRUNCH_RVM_COLOR="%{$fg[magenta]%}"
CRUNCH_DIR_COLOR="%{$fg[cyan]%}"
CRUNCH_GIT_BRANCH_COLOR="%{$fg[green]%}"
CRUNCH_GIT_CLEAN_COLOR="%{$fg[green]%}"
CRUNCH_GIT_DIRTY_COLOR="%{$fg[red]%}"

# These Git variables are used by the oh-my-zsh git_prompt_info helper:
ZSH_THEME_GIT_PROMPT_PREFIX="$CRUNCH_BRACKET_COLOR#$CRUNCH_GIT_BRANCH_COLOR"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=" $CRUNCH_GIT_CLEAN_COLOR✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" $CRUNCH_GIT_DIRTY_COLOR✗"

# Our elements:
CRUNCH_TIME_="$CRUNCH_TIME_COLOR%T %{$reset_color%}"
ZSH_THEME_RUBY_PROMPT_PREFIX="$CRUNCH_BRACKET_COLOR"["$CRUNCH_RVM_COLOR"
ZSH_THEME_RUBY_PROMPT_SUFFIX="$CRUNCH_BRACKET_COLOR"]"%{$reset_color%}"
CRUNCH_RVM_='$(ruby_prompt_info)'
CRUNCH_DIR_="$CRUNCH_DIR_COLOR%~\$(git_prompt_info) "
CRUNCH_PROMPT="$CRUNCH_BRACKET_COLOR❯ "

# ref https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/dieter.zsh-theme

# Check if connected via SSH
if [[ -n "$SSH_CONNECTION" ]]; then
  typeset -g -A host_repr

  # translate hostnames into shortened, colorcoded strings
  host_repr=('dieter-ws-a7n8x-arch' "%{$fg_bold[green]%}ws" 'dieter-p4sci-arch' "%{$fg_bold[blue]%}p4")
  
  # user part, color coded by privileges
  local user="%(!.%{$fg[blue]%}.%{$fg[blue]%})%n%{$reset_color%}"
  
  # Hostname part.  compressed and colorcoded per host_repr array
  # if not found, regular hostname in default color
  local host="@${host_repr[$HOST]:-$HOST}%{$reset_color%}"

  user_host_part="${user}${host}:"
else
  user_host_part=""
fi

# Put it all together
PROMPT="$CRUNCH_TIME_${user_host_part}$CRUNCH_RVM_$CRUNCH_DIR_$CRUNCH_PROMPT%{$reset_color%}"


ORIGINAL_RPROMPT=""

function preexec() {
  timer=$(($(date +%s%0N)/1000000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%0N)/1000000))
    elapsed=$(($now-$timer))
    export RPROMPT="$ORIGINAL_RPROMPT%F{cyan}${elapsed}ms%{$reset_color%}"
    unset timer
  else
    export RPROMPT="$ORIGINAL_RPROMPT"
  fi
}
