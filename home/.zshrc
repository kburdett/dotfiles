# Interactive zsh setup. Environment variables live in conf/env.zsh (via ~/.zshenv).

source "$DOTFILES/conf/alias.zsh"
[[ -s $DOTFILES/conf/local.sh ]] && source "$DOTFILES/conf/local.sh"   # per-machine, not in git

# --- options ---------------------------------------------------------------------------------
setopt INTERACTIVE_COMMENTS   # allow # comments on the command line (handy when pasting)
setopt NO_BEEP

# history
HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=100000
SAVEHIST=100000
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h
setopt INC_APPEND_HISTORY     # write each command as it runs, not when the shell exits
setopt EXTENDED_HISTORY       # record timestamps and durations
setopt HIST_IGNORE_DUPS       # skip a command identical to the one before it
setopt HIST_EXPIRE_DUPS_FIRST # trim duplicates first when the file is full
setopt HIST_IGNORE_SPACE      # a leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY            # !! and friends expand into the line instead of running

# directory stack
DIRSTACKSIZE=8
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME

# --- colors ----------------------------------------------------------------------------------
# ANSI colors so they follow the terminal's OneDark palette: blue dirs, cyan links, green executables.
# ow/tw keep WSL's world-writable /mnt/c folders from showing as blue on green.
export LS_COLORS='rs=0:di=34:ln=36:mh=0:pi=33:so=35:do=35:bd=33:cd=33:or=31:mi=31:su=30;41:sg=30;43:tw=34:ow=34:st=34:ex=32:*.tar=35:*.tgz=35:*.gz=35:*.zip=35:*.7z=35:*.xz=35:*.zst=35'
export GREP_COLORS='mt=3;33'

# --- completion ------------------------------------------------------------------------------
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'   # case-insensitive, then partial words
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{yellow}%B--- %d%b%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format '%F{red}No matches for:%f %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# Rebuild the completion dump at most once a day; otherwise load it without the slow
# security scan of every completion directory (-C).
() {
    local dump=$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
    [[ -d $dump:h ]] || mkdir -p $dump:h
    autoload -Uz compinit
    local -a fresh=($dump(N.mh-24))
    if (( $#fresh )); then
        compinit -C -d $dump
    else
        compinit -d $dump
    fi
}

# --- key bindings (vi mode) ------------------------------------------------------------------
export KEYTIMEOUT=1
bindkey -v
# moving around in history
bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' vi-oper-swap-case
bindkey -a G end-of-buffer-or-history
# fix backspace halting in insert mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-pattern-search-backward

# up/down arrows search history for lines starting with what's typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for key in '^[[A' '^[OA' ${terminfo[kcuu1]}; bindkey $key up-line-or-beginning-search
for key in '^[[B' '^[OB' ${terminfo[kcud1]}; bindkey $key down-line-or-beginning-search
unset key

# hjkl in the completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# edit command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# cursor shape follows the vi mode: beam in insert, block in normal
autoload -Uz add-zle-hook-widget
_cursor_shape() {
    if [[ $KEYMAP == vicmd ]]; then print -n '\e[2 q'; else print -n '\e[6 q'; fi
}
add-zle-hook-widget keymap-select _cursor_shape
add-zle-hook-widget line-init _cursor_shape

# --- prompt (lualine-style, see conf/prompt.zsh) ---------------------------------------------
source "$DOTFILES/conf/prompt.zsh"

# --- optional plugins (apt install zsh-autosuggestions zsh-syntax-highlighting) --------------
# syntax highlighting must be sourced last
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    [[ -r /usr/share/$plugin/$plugin.zsh ]] && source /usr/share/$plugin/$plugin.zsh
done
unset plugin
