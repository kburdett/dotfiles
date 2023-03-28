
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
        export XDG_STATE_HOME="$HOME/Library"
        export XDG_CACHE_HOME="$HOME/Library/Caches"
        ;;
    msys|cygwin)
        export XDG_CONFIG_HOME="$HOME/AppData/Roaming"
        export XDG_DATA_HOME="$HOME/AppData/Local"
        export XDG_STATE_HOME="$HOME/AppData/Local"
        export XDG_CACHE_HOME="$HOME/AppData/Local/Temp"
        ;;
    *)
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_STATE_HOME="$HOME/.local/state"
        export XDG_CACHE_HOME="$HOME/.cache"
        ;;
esac

# Add global NPM binaries to the path
export PATH=~/$XDG_DATA_HOME/npm/bin:$PATH
