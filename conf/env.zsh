# Environment for every zsh (interactive or not), sourced from ~/.zshenv.
# Keep this fast and side-effect free: no output, no external commands.

# editor setup
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-FiRX'   # quit if one screen, smart-case search, keep colors, don't clear the screen

# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# keep tool history out of $HOME
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"

# PATH: user binaries first. `typeset -U` drops duplicates, so nested shells don't grow it.
# Global npm packages live under the prefix set in ~/.npmrc.
typeset -U path PATH
path=(
    "$HOME/.local/bin"
    "$XDG_DATA_HOME/npm-packages/bin"
    $path
)
