#!/bin/bash

dir=$HOME/dotfiles

echo Symlinking dotfiles
for file in $dir/*.symlink; do
    echo "Creating symlink to $file in home directory."
    filename=${file##*/}
    ln -sfn "$file" "$HOME/.${filename%.symlink}"
done

xdg_config=${XDG_CONFIG_HOME-$HOME/.config}
echo Symlinking XDG files to $xdg_config
mkdir -p $xdg_config
for xdg_dir in $dir/xdg/*; do
    target=$xdg_config/${xdg_dir##*/}
    echo "Creating $target => $xdg_dir"
    ln -sfn "$xdg_dir" "$target"
done

if [[ $OSTYPE == darwin* ]]; then
    echo Symlinking OSX gitconfig
    ln -sfn ~/dotfiles/conf/gitconfig.osx ~/.gitconfig.os
fi

