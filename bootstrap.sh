#!/usr/bin/env bash

dir=$(pwd)

echo Importing ENV configuration
# shellcheck source=/dev/null
source "$dir/conf/env.sh"

stow -Rvt "$HOME" home 
stow -Rvt "$XDG_CONFIG_HOME" xdg

