# dotfiles

My home away from home... Git storage for all of my configuration files.

Covers PowerShell on Windows, and zsh on Debian, WSL (Debian) and Termux (Android). The bootstrap scripts link
everything into place and are safe to re-run; anything they would replace is moved aside as
`<name>.bak.<timestamp>`.

## Debian / WSL

```bash
git clone https://github.com/kburdett/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh --packages   # first time: apt packages, Neovim, tree-sitter, zsh as login shell
~/dotfiles/bootstrap.sh              # later: just re-link and install anything new
```

## Termux

For a phone used as an SSH client: zsh, the prompt, a minimal Neovim, and Termux's own settings
(One Dark colors, the CommitMono Nerd Font and an extra-keys row for vi mode). Clone into `~`,
not shared storage (`/sdcard`), where links and executable files don't work.

```bash
pkg install git
git clone https://github.com/kburdett/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh --packages   # first time: zsh, git, gh, openssh, Neovim, termux-api, zsh plugins, zsh as login shell
~/dotfiles/bootstrap.sh              # later
```

It writes the `minimal` profile, so no Neovim plugins or language servers are downloaded.
Also install the [Termux:API](https://wiki.termux.com/wiki/Termux:API) app, from the same source
as Termux (F-Droid or GitHub): the `termux-api` commands, including the clipboard Neovim uses,
hang without it. The bootstrap script warns when the app doesn't respond.
If your user and host names are unhelpful in the prompt, set `_prompt_host=<name>` in `conf/local.sh`.

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

## Profiles

`~/.config/dotfiles/profile` (`$XDG_CONFIG_HOME\dotfiles\profile` on Windows) says how much
Neovim loads:

- `full`: plugins, Tree-sitter parsers and Mason language servers. The bootstrap scripts write
  this the first time they run, so workstations get everything as before (Termux gets `minimal`).
- anything else, or no file: `minimal`. Options, mappings and commands only. No plugins load
  and nothing is downloaded, and it also runs on Debian's Neovim 0.10.

Servers don't run the bootstrap scripts: the infra repo's `shell` role installs these files from a
pinned commit and writes the profile itself. Because a missing file means `minimal`, a server
can't end up downloading plugins by accident.

## Layout

| Path              | Linked to                                                              |
| ----------------- | ---------------------------------------------------------------------- |
| `home/*`          | `~` (Windows: `NPM_CONFIG_USERCONFIG` instead)                         |
| `xdg/*`           | `~/.config` (`%APPDATA%` on Windows)                                   |
| `win/profile.ps1` | loaded by the PowerShell 7 and 5.1 profiles                            |
| `conf/`           | sourced by `.zshenv` / `.zshrc`                                        |
| `script/`         | `update-nvim`, `update-tree-sitter`, `update-git-credential-libsecret` |
| `fonts/`          | `~/.local/share/fonts/dotfiles` (Windows: installed for the user)      |
| `termux/*`        | `~/.termux` (Termux only; the regular font is linked as `font.ttf`)    |

Per-machine settings that aren't checked in: `xdg/git/config.local`, `conf/local.sh` (zsh) and
`win/local.ps1` (PowerShell).

## Git credentials

HTTPS everywhere, with a credential helper per host and OS:

|         | GitHub     | Forgejo (`git.kevinburdett.com`, access token)        |
| ------- | ---------- | ----------------------------------------------------- |
| Windows | GitHub CLI | Git Credential Manager (Windows Credential Manager)   |
| WSL     | GitHub CLI | Windows' Git Credential Manager (shared with Windows) |
| Debian  | GitHub CLI | libsecret (GNOME Keyring / KWallet)                   |
| Termux  | GitHub CLI | `git credential-store` file in `~/.local/state/git`   |

Run `gh auth login` once for GitHub. For Forgejo, enter your username and a personal access
token (Settings → Applications) the first time Git asks. The bootstrap scripts pick the files
for the OS: `xdg/git/config.win`, or `config.linux` plus `config.wsl` / `config.debian` /
`config.termux`.

A [Nerd Font](https://www.nerdfonts.com/) is needed for the prompt glyphs. The bootstrap scripts
install the fonts in `fonts/` (CommitMono Nerd Font): per user on Windows, with no admin rights,
by linking the folder into `~/.local/share/fonts` on Debian, and as `~/.termux/font.ttf` on
Termux (no restart needed there). WSL skips them, since Windows
Terminal uses the fonts installed on Windows. Restart the terminal afterwards and pick the font
in its settings.
