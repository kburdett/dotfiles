#!/bin/bash

# Setup NVM
if [[ -n $(command -v brew 2>/dev/null) && -f $(brew --prefix nvm)/nvm.sh ]]; then
    NVMSH=$(brew --prefix nvm)/nvm.sh
    export NVM_DIR=~/.nvm
    source $NVMSH
fi
