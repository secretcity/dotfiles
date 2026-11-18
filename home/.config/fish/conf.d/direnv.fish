# Replace Homebrew's keg-pinned vendor hook with one generated through PATH.
# Existing Fish processes retain the hook after `brew upgrade direnv`; invoking
# the stable `direnv` command keeps them working when the old Cellar keg is removed.
if command -q direnv
    direnv hook fish | source
end
