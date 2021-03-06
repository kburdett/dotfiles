#! /usr/bin/env bash

# ls aliases
case $OSTYPE in
    darwin*|freebsd*|openbsd)
		# BSD
        alias ls='ls -Gph'
        alias ll='ls -Gphl'
        alias la='ls -Gphal'
        alias listen-ports='lsof -PiTCP -sTCP:LISTEN'
        ;;
    *)
        # Assume GNU
        alias ls='ls -ph --color'
        alias ll='ls -phl --color'
        alias la='ls -phal --color'
        alias listen-ports='netstat -lnp | grep -i "listen"'
        ;;
esac

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

# misc aliases
alias path='echo -e ${PATH//:/\\n}'
alias ping='ping -c 5'
alias ax='chmod a+x'
alias hig='history | grep'
alias mkdir='mkdir -pv'
alias dh='dirs -v'
alias celar='clear'
alias brewup='brew update && brew upgrade && brew cleanup'

