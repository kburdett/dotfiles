#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bash setup
ln -sfh $DIR/bash_profile ~/.bash_profile
ln -sfh $DIR/bashrc ~/.bashrc
ln -sfh $DIR/inputrc ~/.inputrc

# vim setup
ln -sfh $DIR/vimrc ~/.vimrc
ln -sfh $DIR/gvimrc ~/.gvimrc
ln -sfFh $DIR/vim ~/.vim

# git setup
ln -sfh $DIR/gitignore ~/.gitignore
ln -sfh $DIR/gitconfig ~/.gitconfig
