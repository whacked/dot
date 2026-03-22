fpath=($fpath $HOME/.zsh/func)
typeset -U fpath

# Source Home Manager session variables (ZSH, ZSH_PLUGINS_SOURCES, etc.)
# .zshenv is sourced for all zsh instances before .zshrc, making HM-managed
# env vars available before any shell config runs.
[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && \
  source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

