#!/bin/bash

dir=~/dotfiles
olddir=~/dotfiles_old             # old dotfiles backup directory
# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $dir/*.symlink; do
    echo "Creating symlink to $file in home directory."
    filename=${file##*/}
    ln -sfFh $file ~/.${filename%.symlink}
done
