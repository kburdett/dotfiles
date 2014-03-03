####################
# aliases
####################
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX uses BSD ls args
    alias ls='ls -Gph'
    alias ll='ls -Gphal'
else
    # MinGW/Linux use GNU ls args
    alias ls='ls -ph --color'
    alias ll='ls -phal --color'
fi


####################
# bash prompt
####################
source ~/dotfiles/util/git-prompt.sh
export PS1="\[\e[00;32m\]\u@\h\[\e[m\] \[\e[00;33m\]\w\[\e[00;36m\]\$(__git_ps1)\[\e[m\] \$ "
export LS_COLORS='no=00;00:fi=00;00:di=00;32:ln=00;36:pi=00;30;43:so=00;30;43:bd=00;34;43:cd=00;34;43:or=01;05;33;41:mi=01;05;33;41:ex=00;31:'

 # check for Mac OSX
if [[ "$OSTYPE" == "darwin"* ]]; then
    export CLICOLORS=1
    export LSCOLORS=cxgxadadbxededbxbxcxcx
fi

###################
# path
###################
if [[ "$OSTYPE" == "darwin"* ]]; then
    # brew related setup
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
    export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/git/bin
elif [[ "$OSTYPE" == "msys" ]]; then
    # add git to the front of the path
    export PATH="/c/Program Files (x86)/Git/bin:$PATH"
fi
