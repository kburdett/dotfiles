
# Set the homebrew token, not checked into dotfiles for obvious reasons :)
if [[ -s "$HOME/.homebrew_api_token" ]]; then 
    HOMEBREW_API_TOKEN=$(cat "$HOME/.homebrew_api_token")
    export HOMEBREW_API_TOKEN
fi

# editor setup
export EDITOR='nvim'
export VISUAL='nvim'

# Configure XDG paths
case $OSTYPE in
    darwin*)
        export XDG_CONFIG_HOME="$HOME/Library/Preferences"
        export XDG_DATA_HOME="$HOME/Library"
        export XDG_CACHE_HOME="$HOME/Library/Caches" 
        ;;
    msys|cygwin)
        export XDG_CONFIG_HOME="$HOME/AppData/Roaming"
        export XDG_DATA_HOME="$HOME/AppData/Local"
        export XDG_CACHE_HOME="$HOME/AppData/Local/Temp" 
        ;;
esac

