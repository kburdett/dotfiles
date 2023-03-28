#!/usr/bin/env bash

dir=$(pwd)

echo Importing ENV configuration
# shellcheck source=/dev/null
source "$dir/conf/env.sh"

stow -Rvt "$HOME" home
mkdir -p "$XDG_CONFIG_HOME"
stow -Rvt "$XDG_CONFIG_HOME" xdg

# Configure OS specific git config
case $OSTYPE in
    darwin*)
        ln -sf $dir/xdg/git/config.osx $dir/xdg/git/config.os
        ;;
    msys|cygwin)
        ln -sf $dir/xdg/git/config.win $dir/xdg/git/config.os
        ;;
    *)
        ln -sf $dir/xdg/git/config.linux $dir/xdg/git/config.os
        ;;
esac

# Use launchctl (if present) to make XDG paths available system wide
if command -v launchctl &> /dev/null; then
    echo Configuring XDG dirs with launchctl
    launchctl setenv XDG_CONFIG_HOME $XDG_CONFIG_HOME
    launchctl setenv XDG_DATA_HOME $XDG_DATA_HOME
    launchctl setenv XDG_STATE_HOME $XDG_STATE_HOME
    launchctl setenv XDG_CACHE_HOME $XDG_CACHE_HOME
fi
