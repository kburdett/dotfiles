# Lualine-style prompt using lualine's onedark colors.
# Pure zsh; the only external command is one quick `git rev-parse` per prompt.
#
#   [ user@host ]> ~/dotfiles > <branch icon> main rebase >
#
# The first block shows the vi mode like lualine: blue = insert, green = normal.
# The git block shows the branch (or short commit when detached) and any operation
# in progress: rebase, merge, cherry-pick, revert or bisect.
# Separators and the branch icon need a Nerd Font (or set them to plain characters below).

# --- settings --------------------------------------------------------------------------------
typeset -gA _prompt_colors=(
    insert '#61afef'   # blue
    normal '#98c379'   # green
    fg     '#abb2bf'
    bg     '#282c34'
    b      '#3e4452'   # cwd block
    c      '#2c323c'   # git block
    yellow '#e5c07b'   # operation in progress
)
typeset -g _prompt_sep=$'\xee\x82\xb0'     # U+E0B0 powerline arrow (UTF-8 bytes work in any locale)
typeset -g _prompt_branch=$'\xee\x82\xa0'  # U+E0A0 branch icon

# Hex colors are sent as 24-bit; terminals without truecolor get the nearest 256-color match.
[[ $COLORTERM == (truecolor|24bit) ]] || zmodload zsh/nearcolor 2>/dev/null

# --- git -------------------------------------------------------------------------------------
typeset -g _prompt_git=''

_prompt_git_info() {
    _prompt_git=''
    local gitdir
    gitdir=$(git rev-parse --git-dir 2>/dev/null) || return 0   # not in a repository

    # branch: read HEAD directly ("ref: refs/heads/<branch>", or a commit id when detached)
    local head branch action rebase_dir
    [[ -r $gitdir/HEAD ]] || return 0
    head=$(<$gitdir/HEAD)
    if [[ $head == 'ref: '* ]]; then
        branch=${head#ref: refs/heads/}
    else
        branch=${head[1,7]}
    fi

    # operation in progress
    if   [[ -d $gitdir/rebase-merge ]];     then action=rebase rebase_dir=$gitdir/rebase-merge
    elif [[ -d $gitdir/rebase-apply ]];     then action=rebase rebase_dir=$gitdir/rebase-apply
    elif [[ -f $gitdir/MERGE_HEAD ]];       then action=merge
    elif [[ -f $gitdir/CHERRY_PICK_HEAD ]]; then action=cherry-pick
    elif [[ -f $gitdir/REVERT_HEAD ]];      then action=revert
    elif [[ -f $gitdir/BISECT_LOG ]];       then action=bisect
    fi
    # mid-rebase HEAD is detached: show the branch being rebased instead
    if [[ -r $rebase_dir/head-name ]]; then
        branch=$(<$rebase_dir/head-name)
        branch=${branch#refs/heads/}
    fi

    # branch names are shown literally: escape % so they can't inject prompt sequences
    _prompt_git="$_prompt_branch ${branch//\%/%%}"
    if [[ -n $action ]]; then
        _prompt_git+=" %F{$_prompt_colors[yellow]}$action%F{$_prompt_colors[fg]}"
    fi
}

# --- rendering -------------------------------------------------------------------------------
typeset -g _prompt_mode=insert

_prompt_render() {
    local -A c=("${(@kv)_prompt_colors}")
    local mode=$c[$_prompt_mode] sep=$_prompt_sep
    local p="%K{$mode}%F{$c[bg]}%B %n@%m %b"                       # user@host
    p+="%K{$c[b]}%F{$mode}$sep%F{$c[fg]} %(4~|…/%3~|%~) "          # cwd, last 3 dirs when deep
    if [[ -n $_prompt_git ]]; then
        p+="%K{$c[c]}%F{$c[b]}$sep%F{$c[fg]} $_prompt_git %F{$c[c]}"  # git
    else
        p+="%F{$c[b]}"
    fi
    PROMPT="$p%k$sep%f "
}

_prompt_precmd() {
    _prompt_git_info
    _prompt_mode=insert
    _prompt_render
}

# recolor on vi mode changes (no git call, so this is instant)
_prompt_keymap_select() {
    local mode=insert
    [[ $KEYMAP == vicmd ]] && mode=normal
    [[ $mode == $_prompt_mode ]] && return
    _prompt_mode=$mode
    _prompt_render
    zle reset-prompt
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd
zle -N zle-keymap-select _prompt_keymap_select
