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

# "compatibility" aliases... they don't do much but I type them out of habit
Set-Alias -Name 'ls' Get-ChildItem
Set-Alias -Name 'll' Get-ChildItem
Set-Alias -Name 'la' Get-ChildItem
Set-Alias -Name 'celar' Clear-Host

# cd aliases
Function Go-UpDir { Set-Location -Path .. }
Set-Alias -Name '..' Go-UpDir
Function Go-Up2Dirs { Set-Location -Path ..\.. }
Set-Alias -Name '...' Go-Up2Dirs
Set-Alias -Name '.2' Go-UpDir
Function Go-Up3Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '....' Go-Up3Dirs
Set-Alias -Name '.3' Go-UpDir
Function Go-Up4Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '.....' Go-Up4Dirs
Set-Alias -Name '.4' Go-UpDir
Function Go-Up5Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '......' Go-Up5Dirs
Set-Alias -Name '.5' Go-UpDir
Function Go-Up6Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '.......' Go-Up6Dirs
Set-Alias -Name '.6' Go-UpDir
Function Go-Up7Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '........' Go-Up7Dirs
Set-Alias -Name '.7' Go-UpDir
Function Go-Up8Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '.........' Go-Up8Dirs
Set-Alias -Name '.8' Go-UpDir
Function Go-Up9Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '..........' Go-Up9Dirs
Set-Alias -Name '.9' Go-UpDir
Function Go-Up10Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '...........' Go-Up10Dirs
Set-Alias -Name '.10' Go-UpDir
Function Go-Up11Dirs { Set-Location -Path ..\..\.. }
Set-Alias -Name '............' Go-Up11Dirs
Set-Alias -Name '.11' Go-UpDir
