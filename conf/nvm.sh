#!/bin/bash

# Setup NVM
if ! [ hash brew 2>/dev/null ]; then
    NVMSH=$(brew --prefix nvm)/nvm.sh
    if [ -f ~/.homebrew_api_token ]; then
        export NVM_DIR=~/.nvm
        source $NVMSH
    fi
fi
