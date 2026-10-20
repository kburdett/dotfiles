# Sourced by every zsh. ~/.zshenv is a symlink into the repo, so resolve it (:A) to find
# the repo wherever it was cloned.
export DOTFILES=${${(%):-%x}:A:h:h}

# Ubuntu's /etc/zsh/zshrc runs its own compinit; ours in .zshrc is faster (cached)
skip_global_compinit=1

source "$DOTFILES/conf/env.zsh"
