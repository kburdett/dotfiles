# dotfiles

My home away from home... Git storage for all of my configuration files.

Covers PowerShell on Windows, and zsh on Debian and WSL (Debian). The bootstrap scripts link
everything into place and are safe to re-run; anything they would replace is moved aside as
`<name>.bak.<timestamp>`.

## Debian / WSL

```bash
git clone https://github.com/kburdett/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh --packages   # first time: apt packages, Neovim, tree-sitter, zsh as login shell
~/dotfiles/bootstrap.sh              # later: just re-link and install anything new
```

## Windows

Symbolic links need Developer Mode (Settings > System > For developers) with PowerShell 7,
or an elevated shell.

```powershell
git clone https://github.com/kburdett/dotfiles.git $HOME\dotfiles
& $HOME\dotfiles\bootstrap.ps1 -Packages   # first time: also installs tools with winget
& $HOME\dotfiles\bootstrap.ps1             # later
```

Both scripts install the Neovim plugins, Tree-sitter parsers and Mason language servers, and
ask for your Git name and email the first time (saved to `xdg/git/config.local`). Re-running
after a pull also syncs plugins to `nvim-pack-lock.json` and removes plugins dropped from the
config.

## Layout

| Path              | Linked to                                        |
| ----------------- | ------------------------------------------------ |
| `home/*`          | `~`                                              |
| `xdg/*`           | `~/.config` (`%APPDATA%` on Windows)             |
| `win/profile.ps1` | the PowerShell 7 and Windows PowerShell profiles |
| `conf/`           | sourced by `.zshenv` / `.zshrc`                  |
| `script/`         | `update-nvim`, `update-tree-sitter`              |

Per-machine settings that aren't checked in: `xdg/git/config.local`, `conf/local.sh` (zsh) and
`win/local.ps1` (PowerShell).

A [Nerd Font](https://www.nerdfonts.com/) is needed for the prompt glyphs.
