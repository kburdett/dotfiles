# editor setup
$Env:EDITOR = "nvim"
$Env:VISUAL = "nvim"

# XDG directories setup
$Env:XDG_CONFIG_HOME = "$Env:APPDATA"
$Env:XDG_DATA_HOME = "$Env:LOCALAPPDATA"
$Env:XDG_CACHE_HOME = "$Env:TEMP"

# Set vi mode for readline
Set-PSReadlineOption -EditMode vi
