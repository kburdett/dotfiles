####################
# configuration
####################
# prompt
source ~/dotfiles/util/git-prompt.sh
export PS1="\[\e[00;32m\]\u@\h\[\e[m\] \[\e[00;33m\]\w\[\e[00;36m\]\$(__git_ps1)\[\e[m\] \$ "
export LS_COLORS='no=00;00:fi=00;00:di=00;32:ln=00;36:pi=00;30;43:so=00;30;43:bd=00;34;43:cd=00;34;43:or=01;05;33;41:mi=01;05;33;41:ex=00;31:'
# Export BSD colors as well
export CLICOLORS=1
export LSCOLORS=cxgxadadbxededbxbxcxcx

# bash completion
if [[ "$OSTYPE" == "darwin"* && -f $(brew --prefix)/etc/bash_completion ]]; then
    # configure bash completion from the brew path
    . $(brew --prefix)/etc/bash_completion
fi


####################
# aliases
####################
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX uses BSD ls args
    alias ls='ls -Gph'
    alias ll='ls -Gphl'
    alias la='ls -Gphal'
else
    # MinGW/Linux use GNU ls args
    alias ls='ls -ph --color'
    alias ll='ls -phl --color'
    alias la='ls -phal --color'
fi

# cd aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias .7='cd ../../../../../../..'
alias .8='cd ../../../../../../../..'
alias .9='cd ../../../../../../../../..'
alias .10='cd ../../../../../../../../../..'
alias .11='cd ../../../../../../../../../../..'

# grep aliases
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# other aliases
alias path='echo -e ${PATH//:/\\n}'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ax='chmod a+x'
alias src='source ~/.bash_profile'
alias hig='history | grep'
alias mkdir='mkdir -pv'
