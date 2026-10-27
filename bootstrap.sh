#!/usr/bin/env bash
# Set up these dotfiles on Debian, WSL (Debian) or Termux (Android). Safe to re-run at any time.
#
#   ./bootstrap.sh              link configs into $HOME and ~/.config, link the fonts, and
#                               install the Neovim plugins, parsers and language servers
#   ./bootstrap.sh --packages   also install packages, install Neovim and the tree-sitter CLI,
#                               and make zsh the login shell (apt with sudo; pkg on Termux)
#
# Neovim plugins are installed and loaded only under the "full" profile, which this script
# sets the first time it runs (~/.config/dotfiles/profile). Termux gets "minimal" instead: a
# phone used as an SSH client doesn't need language servers. Servers use the infra repo.
#
# Existing files that would be replaced are moved aside as <name>.bak.<timestamp>.
set -euo pipefail

DOTFILES=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

packages=false
for arg in "$@"; do
    case $arg in
        --packages) packages=true ;;
        -h|--help) sed -n '2,/^set /s/^# \{0,1\}//p' "$0"; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

step() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }

# Termux, WSL or native Debian: they differ in packages, fonts and how Git stores the Forgejo
# token (xdg/git/config.<os>). Termux sets TERMUX_VERSION; its prefix is the fallback check.
if [[ -n ${TERMUX_VERSION:-} || ${PREFIX:-} == */com.termux/* ]]; then
    os=termux
elif grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
    os=wsl
else
    os=debian
fi

# Termux has its own chsh, which points ~/.termux/shell at the shell (no passwd entry, no sudo)
login_shell_is_zsh() {
    if [[ $os == termux ]]; then
        [[ $(readlink "$HOME/.termux/shell" 2>/dev/null) == */zsh ]]
    else
        [[ $(getent passwd "${USER:-$(id -un)}" | cut -d: -f7) == */zsh ]]
    fi
}

# link <target> <link>: point <link> at <target>, leaving it alone if it already does
link() {
    local target=$1 link=$2
    if [[ -L $link && $link -ef $target ]]; then
        echo "  ok      $link"
        return
    fi
    if [[ -L $link ]]; then
        rm "$link"   # a symlink pointing somewhere else (or nowhere)
    elif [[ -e $link ]]; then
        local backup
        backup="$link.bak.$(date +%Y%m%d%H%M%S)"
        mv "$link" "$backup"
        echo "  backup  $link -> $backup"
    fi
    ln -s "$target" "$link"
    echo "  linked  $link -> $target"
}

# link_children <dir> <dest>: link every entry of <dir> into <dest>
link_children() {
    local src=$1 dest=$2 entry
    mkdir -p "$dest"
    for entry in "$src"/* "$src"/.[!.]*; do
        [[ -e $entry ]] || continue
        link "$entry" "$dest/$(basename "$entry")"
    done
}

if $packages && [[ $os == termux ]]; then
    step "Installing packages"
    # just enough for an SSH client with this shell and a minimal Neovim, plus the GitHub CLI
    # and termux-api's commands (clipboard, notifications...; they need the Termux:API app)
    pkg install -y zsh git openssh neovim gh termux-api

    step "Installing zsh plugins"
    # Termux doesn't package these; .zshrc also looks for them in $XDG_DATA_HOME/zsh/plugins
    for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
        dir=$XDG_DATA_HOME/zsh/plugins/$plugin
        if [[ -d $dir/.git ]]; then
            git -C "$dir" pull -q --ff-only
            echo "  updated $dir"
        else
            git clone -q --depth 1 "https://github.com/zsh-users/$plugin.git" "$dir"
            echo "  cloned  $dir"
        fi
    done

    if ! login_shell_is_zsh; then
        step "Making zsh the login shell"
        chsh -s zsh
    fi
elif $packages; then
    step "Installing packages"
    sudo apt-get update
    # zsh + plugins, git + GitHub CLI, compilers and archive tools for Mason and tree-sitter,
    # and node/npm for the npm-based language servers (gettext-base: git submodule needs envsubst).
    # Native Debian also builds Git's libsecret credential helper (WSL uses GCM from Windows)
    # and needs fontconfig for the fonts.
    extra=()
    [[ $os == debian ]] && extra=(pkg-config libsecret-1-dev fontconfig)
    sudo apt-get install -y \
        zsh zsh-autosuggestions zsh-syntax-highlighting \
        git git-lfs gh gettext-base \
        curl ca-certificates build-essential unzip tar gzip \
        nodejs npm "${extra[@]}"

    if [[ $os == debian ]]; then
        step "Building Git's libsecret credential helper"
        "$DOTFILES/script/update-git-credential-libsecret"
    fi

    step "Installing Neovim"
    "$DOTFILES/script/update-nvim"

    step "Installing the tree-sitter CLI"
    "$DOTFILES/script/update-tree-sitter" || echo "Skipped: Neovim falls back to regex highlighting"

    if ! login_shell_is_zsh; then
        step "Making zsh the login shell"
        sudo chsh -s "$(command -v zsh)" "${USER:-$(id -un)}"
    fi
fi

step "Linking dotfiles into $HOME"
link_children "$DOTFILES/home" "$HOME"

step "Linking configs into $XDG_CONFIG_HOME"
link_children "$DOTFILES/xdg" "$XDG_CONFIG_HOME"

if [[ $os == termux ]]; then
    step "Linking Termux settings into ~/.termux"
    # the files, not the folder: Termux keeps its own state in ~/.termux too (e.g. chsh's link)
    link_children "$DOTFILES/termux" "$HOME/.termux"
fi

step "Installing fonts"
if [[ $os == wsl ]]; then
    # Windows Terminal draws WSL's text with Windows' fonts
    echo "  skipped: on WSL, run bootstrap.ps1 on Windows to install them"
elif [[ $os == termux ]]; then
    # Termux draws everything with one file, ~/.termux/font.ttf (OpenType works despite the name)
    link "$DOTFILES/fonts/CommitMonoNerdFont-Regular.otf" "$HOME/.termux/font.ttf"
else
    # the whole folder is linked, so fonts added to the repo later show up after a pull
    mkdir -p "$XDG_DATA_HOME/fonts"
    link "$DOTFILES/fonts" "$XDG_DATA_HOME/fonts/dotfiles"
    if command -v fc-cache >/dev/null; then
        fc-cache "$XDG_DATA_HOME/fonts"   # quick when nothing changed
    else
        echo "  fc-cache not found: install fontconfig (or re-run with --packages)"
    fi
fi

if [[ $os == termux ]] && command -v termux-reload-settings >/dev/null; then
    termux-reload-settings   # apply the font, colors and extra keys without restarting Termux
fi

step "Creating XDG directories"
mkdir -p "$XDG_DATA_HOME" "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"
[[ $os == termux ]] && mkdir -p "$XDG_STATE_HOME/git"   # Forgejo token (xdg/git/config.termux)
# zsh history used to live in ~/.histfile
if [[ -f $HOME/.histfile && ! -e $XDG_STATE_HOME/zsh/history ]]; then
    mv "$HOME/.histfile" "$XDG_STATE_HOME/zsh/history"
    echo "  moved   ~/.histfile -> $XDG_STATE_HOME/zsh/history"
fi
rm -f "$HOME"/.zcompdump*   # now cached in $XDG_CACHE_HOME/zsh

step "Setting the profile"
# Neovim loads plugins only when this file says "full" (see xdg/nvim/init.lua). A workstation
# gets "full" the first time and Termux gets "minimal"; an existing file is left alone, so a
# server's "minimal" (written by the infra repo) stays put. Edit the file to switch later.
profile_file=$XDG_CONFIG_HOME/dotfiles/profile
if [[ -s $profile_file ]]; then
    echo "  ok      $profile_file"
else
    mkdir -p "${profile_file%/*}"
    if [[ $os == termux ]]; then echo minimal; else echo full; fi > "$profile_file"
    echo "  wrote   $profile_file"
fi
profile=$(<"$profile_file")
echo "  profile $profile"

step "Configuring Git"
# config.os pulls in the settings for this OS; a regular file, so it works without symlinks
os_config=$DOTFILES/xdg/git/config.os
os_include=$'# Generated by bootstrap.sh\n[include]\n\tpath = config.linux\n\tpath = config.'$os
if [[ ! -L $os_config && -f $os_config && $(<"$os_config") == "$os_include" ]]; then
    echo "  ok      $os_config"
else
    rm -f "$os_config"   # older bootstraps made this a symlink
    printf '%s\n' "$os_include" > "$os_config"
    echo "  wrote   $os_config"
fi

local_config=$DOTFILES/xdg/git/config.local
if [[ -e $local_config ]]; then
    echo "  ok      $local_config"
elif [[ -t 0 ]]; then
    read -rp "  Git user.name:  " name
    read -rp "  Git user.email: " email
    printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email" > "$local_config"
    echo "  wrote   $local_config"
else
    echo "  Create $local_config with your [user] name and email (see config.local.example)"
fi

if [[ $profile != full ]]; then
    step "Skipping Neovim plugins, parsers and language servers ($profile profile)"
elif command -v nvim >/dev/null; then
    step "Installing Neovim plugins, parsers and language servers"
    nvim --headless "+lua require('install')" +qa
fi

step "Done"
if ! $packages && ! login_shell_is_zsh; then
    if [[ $os == termux ]]; then
        echo "zsh isn't your login shell yet: chsh -s zsh  (or re-run with --packages)"
    else
        echo "zsh isn't your login shell yet: chsh -s \"\$(command -v zsh)\"  (or re-run with --packages)"
    fi
fi
command -v gh >/dev/null && ! gh auth status >/dev/null 2>&1 && echo "Sign in to GitHub: gh auth login"
if [[ $os == termux ]]; then
    # termux-api's commands talk to the separate Termux:API app and wait forever when it's missing
    # (or from a different source than Termux), so ask it something harmless with a time limit
    if ! command -v termux-battery-status >/dev/null; then
        echo "termux-api isn't installed: pkg install termux-api (or re-run with --packages)"
    elif ! timeout 10 termux-battery-status >/dev/null 2>&1; then
        echo "The Termux:API app isn't responding: install it from the same place as Termux (F-Droid"
        echo "or GitHub, not a mix). Until then, termux-clipboard-* and Neovim's clipboard will hang."
    fi
fi
if [[ $os == debian && ! -x $HOME/.local/bin/git-credential-libsecret ]]; then
    echo "Git can't save the Forgejo token yet: re-run with --packages, or install pkg-config and"
    echo "libsecret-1-dev and run $DOTFILES/script/update-git-credential-libsecret"
fi
if [[ $os == wsl && ! -x "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe" ]]; then
    echo "Git can't save the Forgejo token yet: install Git for Windows (it includes Git Credential Manager)"
fi
echo "Start a new shell (exec zsh) to load the changes."
