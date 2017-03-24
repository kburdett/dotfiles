#!/usr/bin/env bash

dir=$(pwd)

echo Importing ENV configuration
# shellcheck source=/dev/null
source "$dir/conf/env.sh"

stow -Rt "$HOME" bash
stow -Rt "$HOME" zsh
stow -Rt "$HOME" vim
stow -Rt "$XDG_CONFIG_HOME" neovim
stow -Rt "$XDG_CONFIG_HOME" git

if [[ $OSTYPE == darwin* ]]; then
    echo Deploying OSX gitconfig extenians
    cp -f "$dir/git/git/config.osx" "$dir/git/git/config.os"
fi

