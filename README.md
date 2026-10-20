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

No admin rights or Developer Mode needed: config folders are linked with directory junctions,
and the PowerShell 7 / Windows PowerShell profiles are one-line files that load `win/profile.ps1`.

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

| Path              | Linked to                                                              |
| ----------------- | ---------------------------------------------------------------------- |
| `home/*`          | `~` (Windows: `NPM_CONFIG_USERCONFIG` instead)                         |
| `xdg/*`           | `~/.config` (`%APPDATA%` on Windows)                                   |
| `win/profile.ps1` | loaded by the PowerShell 7 and 5.1 profiles                            |
| `conf/`           | sourced by `.zshenv` / `.zshrc`                                        |
| `script/`         | `update-nvim`, `update-tree-sitter`, `update-git-credential-libsecret` |

Per-machine settings that aren't checked in: `xdg/git/config.local`, `conf/local.sh` (zsh) and
`win/local.ps1` (PowerShell).

## Git credentials

HTTPS everywhere, with a credential helper per host and OS:

|         | GitHub     | Forgejo (`git.kevinburdett.com`, access token)        |
| ------- | ---------- | ----------------------------------------------------- |
| Windows | GitHub CLI | Git Credential Manager (Windows Credential Manager)   |
| WSL     | GitHub CLI | Windows' Git Credential Manager (shared with Windows) |
| Debian  | GitHub CLI | libsecret (GNOME Keyring / KWallet)                   |

Run `gh auth login` once for GitHub. For Forgejo, enter your username and a personal access
token (Settings → Applications) the first time Git asks. The bootstrap scripts pick the files
for the OS: `xdg/git/config.win`, or `config.linux` plus `config.wsl` / `config.debian`.

A [Nerd Font](https://www.nerdfonts.com/) is needed for the prompt glyphs.
