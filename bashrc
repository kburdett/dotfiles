 # check for Mac OSX
if [[ "$OSTYPE" == "darwin"*  ]]; then
    alias ls='ls -Gph'
    alias ll='ls -Gphal'
    export CLICOLORS=1
    export LSCOLORS=cxGxadadbxAdAdbxbxcxcx

    # brew related setup
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
    export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/git/bin
else
    alias ls='ls -ph --color'
    alias ll='ls -phal --color'
    export LS_COLORS='no=00:fi=00;35:di=00;32:ln=01;36:pi=00;30;43:so=00;30;43:bd=01;30;43:cd=01;30;43:or=01;05;37;41:mi=01;05;37;41:ex=00;31:'
fi

# configure the prompt
function EXT_COLOR () { echo -ne "\e[38;5;$1m"; }
function CLOSE_COLOR () { echo -ne '\e[m'; }
export PS1="\[`EXT_COLOR 187`\]\u@\h\[`CLOSE_COLOR`\]\[`EXT_COLOR 174`\] \w \[`CLOSE_COLOR`\]\$> "

