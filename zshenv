# Set wide relative path to zsh; however .zprofile has no been
# sourced as documentation says, that is sourced automatically
# that why a seted below.
#
export ZDOTDIR="$HOME"

# Get aliases
[ -s $HOME/.zsh_aliases ] && source "$ZDOTDIR/.zsh_aliases"

# Get profile
[ -s $HOME/.zprofile ] && source "$ZDOTDIR/.zprofile"

export GTAGSLIBPATH=$HOME/.gtags/
