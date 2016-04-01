# detect homebrew
if [[ $(hash brew 2>/dev/null) ]]; then
    brew_prefix=$(brew --prefix)
fi

# Set the homebrew token, not checked into dotfiles for obvious reasons :)
if [[ -s ~/.homebrew_api_token ]]; then
    export HOMEBREW_API_TOKEN="$(cat ~/.homebrew_api_token)"
fi

# Path modifications
case $OSTYPE in
    darwin*)
        # add brew base path, if present
        if [[ -n $brew_prefix ]]; then
            export PATH="$brew_prefix/bin:$PATH"
        fi
        ;;
    msys|cygwin)
        # move Windows VIM and GIT to the front of the path
        export PATH="/c/Program Files (x86)/Git/bin:$PATH"
        ;;
esac

# Setup NVM
export NVM_DIR=~/.nvm
if [[ -s $NVM_DIR/nvm.sh ]]; then
    source "$NVM_DIR/nvm.sh"
fi
