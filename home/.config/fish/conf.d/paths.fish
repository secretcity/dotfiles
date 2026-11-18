# User paths (use $HOME for portability across machines)
# The dotfiles repo (where `dot` lives), found from this file's real path: stow links it (or its folder) into
# ~/.config/fish, and resolving the link leads back into the repo. Fallback: ~/.dotfiles.
set -l __dotfiles_root (path dirname (path resolve (status filename)))
while test "$__dotfiles_root" != / -a ! -f "$__dotfiles_root/dot"
    set __dotfiles_root (path dirname $__dotfiles_root)
end
if test "$__dotfiles_root" = /
    set __dotfiles_root "$HOME/.dotfiles"
end
fish_add_path "$__dotfiles_root"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.opencode/bin"
fish_add_path "$HOME/.config/opencode/scripts"
fish_add_path "/Applications/Ghostty.app/Contents/MacOS"
