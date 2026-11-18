# Fisher keeps its own files and the plugins' files outside this repository: ~/.config/fish links into the repo, so
# the default place would fill the work tree with untracked files. `dot update` installs what fish_plugins lists
# (docs: https://github.com/jorgebucaran/fisher, "Using your own fisher_path").
set -q XDG_DATA_HOME; or set -l XDG_DATA_HOME $HOME/.local/share
set -g fisher_path $XDG_DATA_HOME/fisher
if test -d $fisher_path
    set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]
    set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
    for file in $fisher_path/conf.d/*.fish
        builtin source $file 2>/dev/null
    end
end
