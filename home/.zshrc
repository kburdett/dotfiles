#!/usr/bin/env zsh

source $HOME/dotfiles/conf/alias.sh
source $HOME/dotfiles/conf/env.sh
[ -s "$HOME/dotfiles/conf/local.sh" ] && source "$HOME/dotfiles/conf/local.sh"

# history
HISTFILE=$HOME/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY 

# directory stack
DIRSTACKSIZE=8
setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome

# colors
export CLICOLOR=1
export KEYTIMEOUT=1
# ls colors (GNU)
export LS_COLORS='no=00;00:fi=00;00:di=00;32:ln=00;36:pi=00;30;43:so=00;30;43:bd=00;34;43:cd=00;34;43:or=01;05;33;41:mi=01;05;33;41:ex=00;31:'
# ls colors (BSD)
export LSCOLORS=cxgxadadbxededbxbxcxcx
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# editor
bindkey -v 
# moving around in history
bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' vi-oper-swap-case
bindkey -a G end-of-buffer-or-history
# fix backspace halting in insert mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward

# completion
# zstyle ':compinstall' filename '$HOME/.zshrc'
# Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "%F{yellow}%B--- %d%b%f"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "%F{red}No matches for:%f %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# ...
autoload -Uz compinit && compinit

# profile aliases
alias src='source $HOME/.zshrc'
alias zshp='$EDITOR $HOME/.zshrc $HOME/.zshenv'

# prompt
setopt prompt_subst
autoload -U colors && colors
autoload -Uz vcs_info 
zstyle ':vcs_info:*' enable git 
zstyle ':vcs_info:*' formats  ' %F{cyan}(%b)'
zstyle ':vcs_info:*' actionformats ' %F{cyan}(%b %F{yellow}%a%F{cyan})'

precmd () { vcs_info }
vi_mode_prompt_info() { echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}" } 
PROMPT='%F{green}%~${vcs_info_msg_0_} %f$ ' 
MODE_INDICATOR='%F{red}%B --NORMAL--%b%f'
RPROMPT='$(vi_mode_prompt_info)'

function zle-line-init zle-keymap-select {
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# up arrow partial completions
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# edit command line in $EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

