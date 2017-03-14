#!/bin/bash

dir=$HOME/dotfiles

echo Importing ENV configuration
source $dir/conf/env.sh

echo Symlinking dotfiles
for file in $dir/*.symlink; do
    echo "Creating symlink to $file in home directory."
    filename=${file##*/}
    ln -sfn "$file" "$HOME/.${filename%.symlink}"
done

# source bashrc here to bring in environment changes
source $HOME/.bashrc

xdg_config=${XDG_CONFIG_HOME-$HOME/.config}
echo Symlinking XDG files to $xdg_config
mkdir -p $xdg_config
for xdg_dir in $dir/xdg/*; do
    target=$xdg_config/${xdg_dir##*/}
    echo "Creating $target => $xdg_dir"
    ln -sfn "$xdg_dir" "$target"
done

if [[ $OSTYPE == darwin* ]]; then
    echo Deploying OSX gitconfig extenians 
    cp -f $dir/xdg/git/config.osx $dir/xdg/git/config.os 
fi

