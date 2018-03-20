#!/usr/bin/env bash

dir=$(pwd)

echo Importing ENV configuration
# shellcheck source=/dev/null
source "$dir/conf/env.sh"

stow -Rvt "$HOME" home 
stow -Rvt "$XDG_CONFIG_HOME" xdg

ln -s $dir/xdg/git/config.osx $dir/xdg/git/config.os

