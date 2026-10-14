# Lualine-style prompt, matching conf/prompt.zsh (onedark colors).
# Dot-source this from the profile, after the PSReadLine options:
#   . "$HOME\dotfiles\win\prompt.ps1"
#
#   [ user@host ]> ~\dotfiles > <branch icon> main rebase >
# The first block shows the vi mode like lualine: blue = insert, green = normal.
# The git block shows the branch (or short commit when detached) and any operation in
# progress: rebase, merge, cherry-pick, revert or bisect. One quick `git rev-parse` per prompt.
# Needs a Nerd Font and a terminal with 24-bit color, such as Windows Terminal.
# Works in PowerShell 7 and Windows PowerShell 5.1 (glyphs are built with [char] for that reason).
$PromptColors = @{
    insert = '#61afef'   # blue
    normal = '#98c379'   # green
    fg     = '#abb2bf'
    bg     = '#282c34'
    b      = '#3e4452'   # cwd block
    c      = '#2c323c'   # git block
    yellow = '#e5c07b'   # operation in progress
}

$PromptState = @{
    Mode       = 'insert'
    Git        = ''
    RedrawOnly = $false
    HasGit     = [bool](Get-Command git -CommandType Application -ErrorAction SilentlyContinue)
    Sep        = [string][char]0xE0B0   # powerline arrow
    Branch     = [string][char]0xE0A0   # branch icon
    Ellipsis   = [string][char]0x2026
    Esc        = [string][char]27
}

function Get-PromptAnsi([string]$Layer, [string]$Hex) {
    # $Layer: 38 = foreground, 48 = background
    $r = [Convert]::ToInt32($Hex.Substring(1, 2), 16)
    $g = [Convert]::ToInt32($Hex.Substring(3, 2), 16)
    $b = [Convert]::ToInt32($Hex.Substring(5, 2), 16)
    "$($PromptState.Esc)[$Layer;2;$r;$g;${b}m"
}

function Get-PromptGitInfo {
    if (-not $PromptState.HasGit -or $PWD.Provider.Name -ne 'FileSystem') { return '' }
    $gitDir = git rev-parse --absolute-git-dir 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $gitDir) { return '' }   # not in a repository

    # branch: read HEAD directly ("ref: refs/heads/<branch>", or a commit id when detached)
    $headFile = Join-Path $gitDir 'HEAD'
    if (-not [IO.File]::Exists($headFile)) { return '' }
    $head = [IO.File]::ReadAllText($headFile).Trim()
    if ($head.StartsWith('ref: ')) { $branch = $head -replace '^ref: refs/heads/', '' }
    else { $branch = $head.Substring(0, [Math]::Min(7, $head.Length)) }

    # operation in progress
    $action = ''
    $rebaseDir = ''
    if ([IO.Directory]::Exists("$gitDir/rebase-merge"))       { $action = 'rebase'; $rebaseDir = "$gitDir/rebase-merge" }
    elseif ([IO.Directory]::Exists("$gitDir/rebase-apply"))   { $action = 'rebase'; $rebaseDir = "$gitDir/rebase-apply" }
    elseif ([IO.File]::Exists("$gitDir/MERGE_HEAD"))          { $action = 'merge' }
    elseif ([IO.File]::Exists("$gitDir/CHERRY_PICK_HEAD"))    { $action = 'cherry-pick' }
    elseif ([IO.File]::Exists("$gitDir/REVERT_HEAD"))         { $action = 'revert' }
    elseif ([IO.File]::Exists("$gitDir/BISECT_LOG"))          { $action = 'bisect' }
    # mid-rebase HEAD is detached: show the branch being rebased instead
    if ($rebaseDir -and [IO.File]::Exists("$rebaseDir/head-name")) {
        $branch = [IO.File]::ReadAllText("$rebaseDir/head-name").Trim() -replace '^refs/heads/', ''
    }

    $info = "$($PromptState.Branch) $branch"
    if ($action) {
        $info += " $(Get-PromptAnsi 38 $PromptColors.yellow)$action$(Get-PromptAnsi 38 $PromptColors.fg)"
    }
    $info
}

function Get-PromptPath {
    # like zsh's %~ : home as ~, and only the last 3 folders when deeper than that
    $path = $PWD.Path
    $homeDir = $HOME.TrimEnd('\', '/')
    if ($path.StartsWith($homeDir, [StringComparison]::OrdinalIgnoreCase) -and
        ($path.Length -eq $homeDir.Length -or $path[$homeDir.Length] -in '\', '/')) {
        $path = '~' + $path.Substring($homeDir.Length)
    }
    $sepChar = [IO.Path]::DirectorySeparatorChar
    $parts = @($path -split '[\\/]' | Where-Object { $_ })
    if ($parts.Count -ge 4) {
        $path = $PromptState.Ellipsis + $sepChar + ($parts[-3..-1] -join $sepChar)
    }
    $path
}

function prompt {
    $lastExit = $global:LASTEXITCODE   # the git call below must not clobber the last command's exit code
    if ($PromptState.RedrawOnly) {
        $PromptState.RedrawOnly = $false   # vi mode change: reuse the cached git info
    } else {
        $PromptState.Mode = 'insert'
        $PromptState.Git = Get-PromptGitInfo
    }

    $c = $PromptColors
    $mode = $c[$PromptState.Mode]
    $sep = $PromptState.Sep
    $user = "$([Environment]::UserName)@$([Environment]::MachineName.ToLower())"
    $e = $PromptState.Esc

    $p  = "$(Get-PromptAnsi 48 $mode)$(Get-PromptAnsi 38 $c.bg)$e[1m $user $e[22m"
    $p += "$(Get-PromptAnsi 48 $c.b)$(Get-PromptAnsi 38 $mode)$sep$(Get-PromptAnsi 38 $c.fg) $(Get-PromptPath) "
    if ($PromptState.Git) {
        $p += "$(Get-PromptAnsi 48 $c.c)$(Get-PromptAnsi 38 $c.b)$sep$(Get-PromptAnsi 38 $c.fg) $($PromptState.Git) $(Get-PromptAnsi 38 $c.c)"
    } else {
        $p += Get-PromptAnsi 38 $c.b
    }
    $p += "$e[49m$sep$e[0m "

    $global:LASTEXITCODE = $lastExit
    $p
}

function Update-PromptViMode([string]$Mode) {
    # called by PSReadLine with 'Command' (normal mode) or 'Insert'
    $new = if ($Mode -eq 'Command') { 'normal' } else { 'insert' }
    if ($new -eq $PromptState.Mode) { return }
    $PromptState.Mode = $new
    $PromptState.RedrawOnly = $true
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

# PSReadLine calls this on every vi mode change (overrides ViModeIndicator from the profile)
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler { param($Mode) Update-PromptViMode $Mode }
