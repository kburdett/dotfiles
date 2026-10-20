# PowerShell profile (PowerShell 7 and Windows PowerShell 5.1). bootstrap.ps1 links this file
# into both profile locations and saves the repo path in the DOTFILES user variable.
$DotfilesDir = if ($Env:DOTFILES) { $Env:DOTFILES } else { Join-Path $HOME 'dotfiles' }
. (Join-Path $DotfilesDir 'win\env.ps1')

# Readline configuration
$PSReadLineOptions = @{
    BellStyle = 'Visual'
    EditMode = 'vi'
    ViModeIndicator = 'Prompt'
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
}
# inline suggestions from history (PSReadLine 2.1+, which ships with PowerShell 7; needs a real console)
if ((Get-Module PSReadLine).Version -ge [version]'2.1' -and -not [Console]::IsOutputRedirected) {
    $PSReadLineOptions.PredictionSource = 'History'
}
Set-PSReadLineOption @PSReadLineOptions
# Adjust tab completion to mimic ZSH
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# up/down arrows search history for lines starting with what's typed (like the zsh setup)
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# lualine-style prompt
. (Join-Path $DotfilesDir 'win\prompt.ps1')

# "compatibility" aliases... they don't do much but I type them out of habit
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

# per-machine settings, not in git
$LocalProfile = Join-Path $DotfilesDir 'win\local.ps1'
if (Test-Path $LocalProfile) { . $LocalProfile }
Remove-Variable LocalProfile
