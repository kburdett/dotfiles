#!/bin/bash

dir=~/dotfiles
for file in $dir/*.symlink; do
    echo "Creating symlink to $file in home directory."
    filename=${file##*/}
    ln -sf $file ~/.${filename%.symlink}
done

# Homebrew setup, if OSX
if [[ $OSTYPE == darwin* ]]; then

    # install homebrew
    if [[ ! $(command -v brew 2>/dev/null) ]]; then
        echo "Mac without homebrew?!?! Fixing..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew already installed"

    # install brew bundle
    if [[ ! $(brew bundle check) ]]; then
        echo "Found missing packages, installing Homebrew bundle"
        brew bundle
    else
        echo "Homebrew bundle reports all packages installed"
    fi

fi
