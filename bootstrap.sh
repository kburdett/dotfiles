#!/bin/bash

dir=~/dotfiles
for file in $dir/*.symlink; do
    echo "Creating symlink to $file in home directory."
    filename=${file##*/}
    ln -sfn $file ~/.${filename%.symlink}
done

