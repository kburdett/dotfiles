# editor setup
$Env:EDITOR = "nvim"
$Env:VISUAL = "nvim"

# XDG directories setup
$Env:XDG_CONFIG_HOME = "$Env:APPDATA"
$Env:XDG_DATA_HOME = "$Env:LOCALAPPDATA"
$Env:XDG_STATE_HOME= "$Env:LOCALAPPDATA"
$Env:XDG_CACHE_HOME = "$Env:TEMP"

# Readline configuration
$PSReadLineOptions = @{
    BellStyle = "Visual"
    EditMode = "vi"
    ViModeIndicator = "Prompt"
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
}
Set-PSReadLineOption @PSReadLineOptions
# Adjust tab completion to mimic ZSH
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# lualine-style prompt
. "$HOME\dotfiles\win\prompt.ps1"

# "compatibility" aliases... they don't do much but I type them out of habit
Set-Alias -Name 'ls' Get-ChildItem
Set-Alias -Name 'll' Get-ChildItem
Set-Alias -Name 'la' Get-ChildItem
Set-Alias -Name 'celar' Clear-Host

# cd shortcuts: ".." goes up one level, "..." two, and so on up to 11 levels; "up 3" also works.
# (zsh's ".2" style can't work in PowerShell: it reads ".2" as the number 0.2)
& {
    foreach ($n in 1..11) {
        $target = (@('..') * $n) -join [IO.Path]::DirectorySeparatorChar
        Set-Item -Path "function:global:$('.' * ($n + 1))" -Value ([scriptblock]::Create("Set-Location -Path '$target'"))
    }
}
function up([int]$Levels = 1) {
    Set-Location -Path ((@('..') * $Levels) -join [IO.Path]::DirectorySeparatorChar)
}
