#! /usr/bin/env bash

#shellcheck source=/dev/null
source $HOME/dotfiles/conf/docker.sh
#shellcheck source=/dev/null
source $HOME/dotfiles/conf/alias.sh
#shellcheck source=/dev/null
source $HOME/dotfiles/conf/env.sh

# prompt
#shellcheck source=/dev/null
source $HOME/dotfiles/util/git-prompt.sh
export PS1="\[\e[00;32m\]\u@\h\[\e[m\] \[\e[00;33m\]\w\[\e[00;36m\]\$(__git_ps1)\[\e[m\] \$ "

# ls colors (GNU)
export LS_COLORS='no=00;00:fi=00;00:di=00;32:ln=00;36:pi=00;30;43:so=00;30;43:bd=00;34;43:cd=00;34;43:or=01;05;33;41:mi=01;05;33;41:ex=00;31:'
# ls colors (BSD)
export LSCOLORS=cxgxadadbxededbxbxcxcx

# bash completion
# check brew path first
if [[ -f "/usr/local/etc/bash_completion" ]]; then
    #shellcheck source=/dev/null
    source /usr/local/etc/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    #shellcheck source=/dev/null
    source /etc/bash_completion
fi 

# profile aliases
alias src='source $HOME/.bash_profile'
alias bashp='$EDITOR $HOME/.bash_profile $HOME/.bashrc'

