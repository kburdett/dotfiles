source ~/dotfiles/util/git-prompt.sh

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
