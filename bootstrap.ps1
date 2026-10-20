<#
.SYNOPSIS
Set up these dotfiles on Windows. Safe to re-run at any time.

.DESCRIPTION
Links the PowerShell profile (for PowerShell 7 and Windows PowerShell 5.1), ~/.npmrc and the
XDG configs (git, nvim) into place, saves the XDG and DOTFILES variables for the user, and
installs the Neovim plugins, parsers and language servers.
Existing files that would be replaced are moved aside as <name>.bak.<timestamp>.

Symbolic links need Developer Mode (Settings > System > For developers) or an elevated shell.

.PARAMETER Packages
Also install Git, the GitHub CLI, Neovim, Node.js, WinMerge and PowerShell 7 with winget.
#>
[CmdletBinding()]
param(
    [switch]$Packages
)
$ErrorActionPreference = 'Stop'

$DotfilesDir = $PSScriptRoot
. (Join-Path $DotfilesDir 'win\env.ps1')

function Write-Step([string]$Message) {
    Write-Host "`n==> $Message" -ForegroundColor Blue
}

function Resolve-LinkTarget([IO.FileSystemInfo]$Item) {
    # .Target is a string in PowerShell 7 and a string[] in 5.1; it may be relative to the link
    $target = @($Item.Target)[0]
    if (-not $target) { return $null }
    if (-not [IO.Path]::IsPathRooted($target)) {
        $target = Join-Path (Split-Path -Parent $Item.FullName) $target
    }
    [IO.Path]::GetFullPath($target).TrimEnd('\')
}

# Fail with a clear message, before anything is moved, if this shell can't make symlinks.
# Checked only when a link is actually needed, so re-runs with everything in place work anywhere.
$script:CanSymlink = $null
function Assert-CanSymlink {
    if ($null -eq $script:CanSymlink) {
        $probe = Join-Path ([IO.Path]::GetTempPath()) "dotfiles-symlink-probe-$PID"
        try {
            New-Item -ItemType SymbolicLink -Path $probe -Target $PSCommandPath | Out-Null
            Remove-Item -LiteralPath $probe
            $script:CanSymlink = $true
        } catch {
            $script:CanSymlink = $false
        }
    }
    if (-not $script:CanSymlink) {
        throw 'Cannot create symbolic links. Turn on Developer Mode (Settings > System > For developers) and use PowerShell 7, or run this from an elevated shell.'
    }
}

# Point $Path at $Target, leaving it alone if it already does
function Set-Link([string]$Target, [string]$Path) {
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -and
        (Resolve-LinkTarget $item) -eq [IO.Path]::GetFullPath($Target).TrimEnd('\')) {
        Write-Host "  ok      $Path"
        return
    }
    Assert-CanSymlink
    if ($item -and $item.LinkType) {
        # a link pointing somewhere else. Delete() removes only the link, never the target's contents
        $item.Delete()
    } elseif ($item) {
        $backup = "$Path.bak.$(Get-Date -Format yyyyMMddHHmmss)"
        Move-Item -LiteralPath $Path -Destination $backup
        Write-Host "  backup  $Path -> $backup"
    }
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent | Out-Null }
    New-Item -ItemType SymbolicLink -Path $Path -Target $Target | Out-Null
    Write-Host "  linked  $Path -> $Target"
}

# Link every entry of $Source into $Destination
function Set-ChildLinks([string]$Source, [string]$Destination, [string[]]$Exclude = @()) {
    foreach ($child in Get-ChildItem -LiteralPath $Source -Force) {
        if ($child.Name -in $Exclude) { continue }
        Set-Link -Target $child.FullName -Path (Join-Path $Destination $child.Name)
    }
}

# Save a user environment variable for all new processes (skipped when unchanged: saving is slow)
function Set-UserEnv([string]$Name, [string]$Value) {
    if ([Environment]::GetEnvironmentVariable($Name, 'User') -eq $Value) {
        Write-Host "  ok      $Name"
        return
    }
    [Environment]::SetEnvironmentVariable($Name, $Value, 'User')
    Write-Host "  set     $Name = $Value"
}

if ($Packages) {
    Write-Step 'Installing packages with winget'
    $ids = 'Git.Git', 'GitHub.cli', 'Neovim.Neovim', 'OpenJS.NodeJS.LTS', 'WinMerge.WinMerge', 'Microsoft.PowerShell'
    foreach ($id in $ids) {
        winget list --exact --id $id --accept-source-agreements *> $null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ok      $id"
        } else {
            winget install --exact --id $id --silent --accept-package-agreements --accept-source-agreements
        }
    }
    # pick up the new commands in this session
    $Env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User')
}

Write-Step 'Linking the PowerShell profile'
$documents = [Environment]::GetFolderPath('MyDocuments')
$profileSource = Join-Path $DotfilesDir 'win\profile.ps1'
foreach ($edition in 'PowerShell', 'WindowsPowerShell') {
    Set-Link -Target $profileSource -Path (Join-Path $documents "$edition\profile.ps1")
}

Write-Step "Linking dotfiles into $HOME"
Set-ChildLinks -Source (Join-Path $DotfilesDir 'home') -Destination $HOME -Exclude '.zshrc', '.zshenv'

Write-Step "Linking configs into $Env:XDG_CONFIG_HOME"
Set-ChildLinks -Source (Join-Path $DotfilesDir 'xdg') -Destination $Env:XDG_CONFIG_HOME

Write-Step 'Saving environment variables for the user'
foreach ($name in 'DOTFILES', 'XDG_CONFIG_HOME', 'XDG_DATA_HOME', 'XDG_STATE_HOME', 'XDG_CACHE_HOME') {
    Set-UserEnv $name ([Environment]::GetEnvironmentVariable($name))
}

Write-Step 'Configuring Git'
# config.os pulls in the settings for this OS; a regular file, so it needs no symlink
$osConfig = Join-Path $DotfilesDir 'xdg\git\config.os'
$osInclude = "# Generated by bootstrap.ps1`n[include]`n`tpath = config.win`n"
$osItem = Get-Item -LiteralPath $osConfig -Force -ErrorAction SilentlyContinue
if ($osItem -and -not $osItem.LinkType -and [IO.File]::ReadAllText($osConfig) -eq $osInclude) {
    Write-Host "  ok      $osConfig"
} else {
    if ($osItem) { $osItem.Delete() }   # older bootstraps made this a symlink
    [IO.File]::WriteAllText($osConfig, $osInclude)
    Write-Host "  wrote   $osConfig"
}

$localConfig = Join-Path $DotfilesDir 'xdg\git\config.local'
if (Test-Path $localConfig) {
    Write-Host "  ok      $localConfig"
} elseif ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
    $name = Read-Host '  Git user.name'
    $email = Read-Host '  Git user.email'
    [IO.File]::WriteAllText($localConfig, "[user]`n`tname = $name`n`temail = $email`n")
    Write-Host "  wrote   $localConfig"
} else {
    Write-Host "  Create $localConfig with your [user] name and email (see config.local.example)"
}

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Write-Step 'Installing Neovim plugins, parsers and language servers'
    nvim --headless "+lua require('install')" +qa
}

Write-Step 'Done'
if (Get-Command gh -ErrorAction SilentlyContinue) {
    gh auth status *> $null
    if ($LASTEXITCODE -ne 0) { Write-Host 'Sign in to GitHub: gh auth login' }
}
Write-Host 'Open a new terminal to load the profile.'
