<#
.SYNOPSIS
Update everything on this PC: winget packages, the WSL platform, and apt in a WSL distro.

.DESCRIPTION
Runs in two passes, because winget refuses to upgrade portable packages installed for the user
(ripgrep, tree-sitter) from an elevated session, and machine-wide packages need one:
  1. In this window, not elevated: winget upgrade --all --scope user
  2. In a new elevated window (one UAC prompt), while this one waits:
       winget upgrade --all     (machine-wide packages, and any whose scope winget doesn't know)
       wsl --update
       apt-get update / full-upgrade / autoremove in the distro, as root (no sudo password)
This window then lists anything that failed in either pass. The elevated window closes when
it's done, unless something failed there.

Always runs in Windows PowerShell 5.1, in conhost (the classic console): winget can't replace
pwsh's files while a pwsh process has them open, or Windows Terminal's while it's in use. Started
from PowerShell 7, it starts itself again that way. bootstrap.ps1 adds an "Update All" Start menu
shortcut that launches it like this.

WSL is updated before apt because updating it can stop the running distros; apt then starts the
distro fresh. The WSL steps are skipped when the distro isn't installed.

.PARAMETER Distro
The WSL distro to run apt in (see wsl -l). Defaults to Debian.

.PARAMETER NoPause
Don't wait for Enter at the end (or when pwsh is running), e.g. from a scheduled task.

.PARAMETER ResultFile
Internal: given to the elevated copy, which runs pass 2 and writes what failed to this file.
#>
[CmdletBinding()]
param(
    [string]$Distro = 'Debian',
    [switch]$NoPause,
    [string]$ResultFile
)

$winPS = Join-Path $Env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$conhost = Join-Path $Env:SystemRoot 'System32\conhost.exe'
$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# arguments for conhost to run this script in Windows PowerShell 5.1
function Get-RelaunchArgs {
    $list = @("`"$winPS`"", '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"", '-Distro', $Distro)
    if ($NoPause) { $list += '-NoPause' }
    $list
}

if ($PSVersionTable.PSEdition -eq 'Core') {
    Start-Process $conhost -ArgumentList (Get-RelaunchArgs)
    exit
}

function Write-Step([string]$Message) {
    Write-Host "`n==> $Message" -ForegroundColor Blue
}

function Wait-Enter([string]$Prompt) {
    if (-not $NoPause) { Read-Host $Prompt | Out-Null }
}

$failed = New-Object 'Collections.Generic.List[string]'

# Record a failed winget run. 0x8A15002B (UPDATE_NOT_APPLICABLE) just means nothing to upgrade.
# (winget itself is run at the top level, not inside a function, so its output and progress bars
# go straight to the console.)
function Add-WingetFailure([string]$Label) {
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
        $failed.Add(('{0} (exit code 0x{1:X8})' -f $Label, $LASTEXITCODE))
    }
}

$elevatedCopy = [bool]$ResultFile

# ---- pass 1: packages installed for this user (not elevated) ----
if (-not $elevatedCopy) {
    # this script runs in 5.1, so any pwsh is another window (VS Code terminals count) holding
    # the files a PowerShell 7 upgrade needs to replace
    $pwsh = @(Get-Process pwsh -ErrorAction SilentlyContinue)
    if ($pwsh.Count -gt 0) {
        Write-Warning "$($pwsh.Count) PowerShell 7 (pwsh) process(es) running: a PowerShell 7 upgrade may fail until they're closed."
        Wait-Enter '  Close them and press Enter (or just press Enter to carry on)'
    }

    if ($isAdmin) {
        Write-Warning 'Running as administrator, so winget can''t upgrade portable packages installed for this user (ripgrep, tree-sitter). Use the Update All shortcut, or run this from a prompt that isn''t elevated.'
    } else {
        Write-Step 'Upgrading winget packages installed for this user'
        winget upgrade --all --scope user --accept-source-agreements --accept-package-agreements --disable-interactivity
        Add-WingetFailure 'winget upgrade --scope user'
    }
}

# ---- pass 2: machine-wide packages, WSL and apt (elevated) ----
if ($elevatedCopy -or $isAdmin) {
    Write-Step 'Upgrading machine-wide winget packages'
    winget upgrade --all --accept-source-agreements --accept-package-agreements --disable-interactivity
    Add-WingetFailure 'winget upgrade (elevated)'

    # wsl -l prints UTF-16; WSL_UTF8 asks for UTF-8, and stripping NULs covers versions that ignore it
    $Env:WSL_UTF8 = '1'
    $distros = @(wsl.exe --list --quiet 2>$null | ForEach-Object { ($_ -replace "`0", '').Trim() } | Where-Object { $_ })
    if ($distros -notcontains $Distro) {
        Write-Step "Skipping WSL: no '$Distro' distro installed"
    } else {
        Write-Step 'Updating WSL'
        wsl.exe --update
        if ($LASTEXITCODE -ne 0) { $failed.Add("wsl --update (exit code $LASTEXITCODE)") }

        Write-Step "Upgrading apt packages in $Distro"
        # one wsl call per command: nothing for PowerShell, wsl and bash to re-quote
        foreach ($aptArgs in @('update'), @('full-upgrade', '-y'), @('autoremove', '-y')) {
            wsl.exe -d $Distro -u root -- apt-get @aptArgs
            if ($LASTEXITCODE -ne 0) {
                $failed.Add("apt-get $($aptArgs -join ' ') (exit code $LASTEXITCODE)")
                break
            }
        }
    }
} else {
    Write-Step 'Running the administrator steps in a new window'
    $resultPath = [IO.Path]::GetTempFileName()
    try {
        $proc = Start-Process $conhost -Verb RunAs -PassThru -ArgumentList ((Get-RelaunchArgs) + '-ResultFile', "`"$resultPath`"")
        # wait for that process only: Start-Process -Wait would also wait for anything it leaves
        # running (WSL's helpers, for one)
        $proc.WaitForExit()
        $result = @(Get-Content -LiteralPath $resultPath)
        if ($result -notcontains 'DONE') {
            $failed.Add('administrator steps: the window closed before they finished')
        }
        foreach ($line in $result) {
            if ($line -and $line -ne 'DONE') { $failed.Add($line) }
        }
    } catch {
        $failed.Add('administrator steps skipped: the UAC prompt was declined')
    }
    Remove-Item -LiteralPath $resultPath -ErrorAction SilentlyContinue
}

if ($failed.Count -gt 0) {
    Write-Step 'Done, with problems:'
    foreach ($item in $failed) { Write-Host "  $item" -ForegroundColor Yellow }
} else {
    Write-Step 'Done'
}

if ($elevatedCopy) {
    # report back to the first window; stay open only if there's something to read here
    Set-Content -LiteralPath $ResultFile -Value (@($failed) + 'DONE') -Encoding UTF8
    if ($failed.Count -gt 0) { Wait-Enter 'Press Enter to close this window' }
    exit
}
Wait-Enter 'Press Enter to close'
if ($failed.Count -gt 0) { exit 1 }
