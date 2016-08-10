#!/bin/bash

echo Symlinking dotfiles
dir=~/dotfiles
for file in $dir/*.symlink; do
    echo "Creating symlink to $file in home directory."
    filename=${file##*/}
    ln -sfn $file ~/.${filename%.symlink}
done

if [[ -z ~/.nvm/nvm.sh ]]; then
    echo Installing NVM
    current=$(pwd)
    git clone https://github.com/creationix/nvm.git ~/.nvm
    cd ~/.nvm
    git checkout $(git describe --abbrev=0 --tags)
    cd $current
fi

if [[ $OSTYPE == darwin* ]]; then
    echo Symlinking OSX gitconfig
    ln -sfn ~/dotfiles/conf/gitconfig.osx ~/.gitconfig.os
fi
