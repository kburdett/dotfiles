# detect homebrew
if [[ $(hash brew 2>/dev/null) ]]; then
    brew_prefix=$(brew --prefix)
fi

# Set the homebrew token, not checked into dotfiles for obvious reasons :)
if [[ -s "$HOME/.homebrew_api_token" ]]; then 
    HOMEBREW_API_TOKEN=$(cat "$HOME/.homebrew_api_token")
    export HOMEBREW_API_TOKEN
fi

# editor setup
nvim=$(which nivm)
nvim=$(which vim)
export EDITOR="${nvim-$vim}"
export VISUAL="${nvim-$vim}"

# Path modifications
case $OSTYPE in
    darwin*)
        # add brew base path, if present
        if [[ -n $brew_prefix ]]; then
            export PATH="$brew_prefix/bin:$PATH"
        fi 
        # configure XDG
        export XDG_CONFIG_HOME="$HOME/Library/Preferences"
        export XDG_DATA_HOME="$HOME/Library"
        export XDG_CACHE_HOME="$HOME/Library/Caches" 
        ;;
    msys|cygwin)
        # move Windows VIM and GIT to the front of the path
        export PATH="/c/Program Files (x86)/Git/bin:$PATH"
        # configure XDG
        export XDG_CONFIG_HOME="$HOME/AppData/Roaming"
        export XDG_DATA_HOME="$HOME/AppData/Local"
        export XDG_CACHE_HOME="$HOME/AppData/Local/Temp" 
        ;;
esac

