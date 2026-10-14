# Lualine-style prompt using lualine's onedark colors.
# Pure zsh; the only external command is git, run once per prompt inside repositories.
#
#    user@host   ~/dotfiles    main ⇡1 +2 ~1 ?3
#
# The first block shows the vi mode like lualine: blue = insert, green = normal.
# Git status: ⇡ahead ⇣behind  !conflicts  +staged  ~modified  ?untracked
# Separators and the branch icon need a Nerd Font (or set them to plain characters below).

# --- settings --------------------------------------------------------------------------------
typeset -gA _prompt_colors=(
    insert '#61afef'   # blue
    normal '#98c379'   # green
    fg     '#abb2bf'
    bg     '#282c34'
    b      '#3e4452'   # cwd block
    c      '#2c323c'   # git block
    green  '#98c379'
    yellow '#e5c07b'
    red    '#e06c75'
    cyan   '#56b6c2'
)
typeset -g _prompt_sep=$''     #
typeset -g _prompt_branch=$''  #

# Hex colors are sent as 24-bit; terminals without truecolor get the nearest 256-color match.
[[ $COLORTERM == (truecolor|24bit) ]] || zmodload zsh/nearcolor 2>/dev/null

# --- git -------------------------------------------------------------------------------------
typeset -g _prompt_git=''

_prompt_git_info() {
    _prompt_git=''
    local -a lines
    lines=(${(f)"$(git status --porcelain=v2 --branch 2>/dev/null)"})
    (( $#lines )) || return 0   # not in a repository

    local line oid branch ahead=0 behind=0 staged=0 changed=0 untracked=0 conflicts=0
    for line in $lines; do
        case $line in
            '# branch.oid '*)  oid=${line#\# branch.oid } ;;
            '# branch.head '*) branch=${line#\# branch.head } ;;
            '# branch.ab '*)   ahead=${${line#\# branch.ab +}%% *}; behind=${line##*-} ;;
            [12]' '*)          # "1 XY ...": X = staged, Y = unstaged ('.' means unchanged)
                               [[ ${line[3]} != . ]] && (( ++staged ))
                               [[ ${line[4]} != . ]] && (( ++changed )) ;;
            'u '*)             (( ++conflicts )) ;;
            '? '*)             (( ++untracked )) ;;
        esac
    done
    # operation in progress (rebase, merge, ...)
    local gitdir action rebase_dir
    gitdir=$(git rev-parse --git-dir 2>/dev/null)
    if   [[ -d $gitdir/rebase-merge ]]; then action=rebase rebase_dir=$gitdir/rebase-merge
    elif [[ -d $gitdir/rebase-apply ]]; then action=rebase rebase_dir=$gitdir/rebase-apply
    elif [[ -f $gitdir/MERGE_HEAD ]];       then action=merge
    elif [[ -f $gitdir/CHERRY_PICK_HEAD ]]; then action=cherry-pick
    elif [[ -f $gitdir/REVERT_HEAD ]];      then action=revert
    elif [[ -f $gitdir/BISECT_LOG ]];       then action=bisect
    fi

    if [[ $branch == '(detached)' ]]; then
        # mid-rebase HEAD is detached: show the branch being rebased, else the short commit
        if [[ -r $rebase_dir/head-name ]]; then
            branch=$(<$rebase_dir/head-name)
            branch=${branch#refs/heads/}
        else
            branch=${oid[1,7]}
        fi
    fi

    local -A c=("${(@kv)_prompt_colors}")
    # branch names are shown literally: escape % so they can't inject prompt sequences
    local s="$_prompt_branch ${branch//\%/%%}"
    [[ -n $action ]]  && s+=" %F{$c[yellow]}$action%F{$c[fg]}"
    (( ahead ))       && s+=" ⇡$ahead"
    (( behind ))      && s+=" ⇣$behind"
    (( conflicts ))   && s+=" %F{$c[red]}!$conflicts"
    (( staged ))      && s+=" %F{$c[green]}+$staged"
    (( changed ))     && s+=" %F{$c[yellow]}~$changed"
    (( untracked ))   && s+=" %F{$c[cyan]}?$untracked"
    _prompt_git=$s
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
