# Environment shared by the profile and bootstrap.ps1 (the Windows side of conf/env.zsh).
# Dot-source it: . "$DotfilesDir\win\env.ps1"

$Env:DOTFILES = Split-Path -Parent $PSScriptRoot

# editor setup
$Env:EDITOR = 'nvim'
$Env:VISUAL = 'nvim'

# XDG directories (Git and Neovim both honor these)
$Env:XDG_CONFIG_HOME = $Env:APPDATA
$Env:XDG_DATA_HOME = $Env:LOCALAPPDATA
$Env:XDG_STATE_HOME = $Env:LOCALAPPDATA
$Env:XDG_CACHE_HOME = $Env:TEMP

# global npm packages live under the prefix set in ~/.npmrc (Windows npm puts them in the prefix itself)
$NpmBin = Join-Path $Env:XDG_DATA_HOME 'npm-packages'
if (($Env:PATH -split ';') -notcontains $NpmBin) { $Env:PATH = "$NpmBin;$Env:PATH" }
Remove-Variable NpmBin
