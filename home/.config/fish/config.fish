# Disable greeting
set fish_greeting 

# Set Editor to micro
set -gx EDITOR 'micro'

# The dotfiles directory (the 'dot' command) is put on PATH in conf.d/paths.fish.

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
