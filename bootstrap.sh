#!/usr/bin/env bash

dir=$(pwd)

echo Importing ENV configuration
# shellcheck source=/dev/null
source "$dir/conf/env.sh"

function stow_all {
    sub=$1
    destination=$2
    for stow_dir in $sub/*; do
        echo "Stowing $stow_dir -> $destination"
	stow -R -d "$sub" -t "$destination" "$(basename $stow_dir)"
    done 
}

stow_all "home" "$HOME"
stow_all "xdg" "$XDG_CONFIG_HOME"

