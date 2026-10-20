# Interactive aliases, sourced from ~/.zshrc. Assumes GNU coreutils (Debian / WSL).

# ls
alias ls='ls -ph --color=auto'
alias ll='ls -phl --color=auto'
alias la='ls -phal --color=auto'

# grep (GREP_OPTIONS is no longer read by grep)
alias grep='grep --color=auto'

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
alias path='print -rl -- $path'
alias ping='ping -c 5'
alias ax='chmod a+x'
alias hig='fc -l 1 | grep'   # search all history (plain `history` only lists the last 16)
alias mkdir='mkdir -pv'
alias dh='dirs -v'
alias celar='clear'
alias listen-ports='ss -ltnp'

# profile aliases
alias src='source $HOME/.zshrc'
alias zshp='$EDITOR $HOME/.zshrc $HOME/.zshenv'

# WSL: open files and folders with Windows
if [[ -n $WSL_DISTRO_NAME ]]; then
    alias open='explorer.exe'
fi
