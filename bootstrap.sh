#!/usr/bin/env bash

dir=$(pwd)

echo Importing ENV configuration
# shellcheck source=/dev/null
source "$dir/conf/env.sh"

echo Stowing home directory files
stow -Rt "$HOME" home

echo Stowing XDG config files
stow -Rt "$XDG_CONFIG_HOME" xdg

