#!/bin/bash

echo Symlinking dotfiles
dir=~/dotfiles
for file in $dir/*.symlink; do
    echo "Creating symlink to $file in home directory."
    filename=${file##*/}
    ln -sfn $file ~/.${filename%.symlink}
done

if [[ $OSTYPE == darwin* ]]; then
    echo Symlinking OSX gitconfig
    ln -sfn ~/dotfiles/conf/gitconfig.osx ~/.gitconfig.os
fi
