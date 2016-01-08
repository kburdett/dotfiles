# detect homebrew
if [[ $(command -v brew 2>/dev/null) ]]; then
    $brew_prefix = $(brew --prefix)
fi

# Set the homebrew token, not checked into dotfiles for obvious reasons :)
if [ -f ~/.homebrew_api_token ]; then
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
if [[ -n $brew_prefix && -f $brew_prefix/nvm.sh ]]; then
    NVMSH=$brew_prefix/nvm.sh
    export NVM_DIR=~/.nvm
fi
