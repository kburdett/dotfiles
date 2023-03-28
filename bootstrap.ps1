$DotfilesDir = Split-Path -parent $PSCommandPath

# configure the powershell profile
Write-Host "Deploying powershell profile"
$DotfilesProfile = Join-Path -Path $DotfilesDir -ChildPath "win" -AdditionalChildPath "profile.ps1"
Write-Host "Symlinking gitconfig ""$Profile.CurrentUserAllHosts"" --> ""$DotfilesProfile"""
New-Item -ItemType SymbolicLink -Path $Profile.CurrentUserAllHosts -Target $DotfilesProfile -Force

# source the profile for XDG dirs
& $Profile.CurrentUserAllHosts

function Link-All {

    param (
        [string]$TargetPath,
        [string]$LinkPath
    )

    foreach ($Child in Get-ChildItem -Path $TargetPath -Name -Force) {
        $LinkFqn = Join-Path -Path $LinkPath -ChildPath $Child
        $TargetFqn = Join-Path -Path $TargetPath -ChildPath $Child

        Write-Host "Symlinking $Child ""$LinkFqn"" to ""$TargetFqn"""
        New-Item -ItemType SymbolicLink -Path $LinkFqn -Target $TargetFqn -Force
    }
}


Write-Host "Deploying XDG configurations to ""$Env:XDG_CONFIG_HOME"""
$XdgDotfilesDir = Join-Path -Path $DotfilesDir -ChildPath "xdg"
Link-All -TargetPath $XdgDotfilesDir -LinkPath $Env:XDG_CONFIG_HOME

Write-Host "Deploying dotfiles to ""$Env:USERPROFILE"""
$HomeDotfilesDir = Join-Path -Path $DotfilesDir -ChildPath "home"
Link-All -TargetPath $HomeDotfilesDir -LinkPath $Env:USERPROFILE


# Use SetEnvironmentVariable to persist these for all applications
Write-Host "Persisting XDG directories to User profile"

# XDG directories setup
[Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', $Env:XDG_CONFIG_HOME, 'User')
[Environment]::SetEnvironmentVariable('XDG_DATA_HOME', $Env:XDG_DATA_HOME, 'User')
[Environment]::SetEnvironmentVariable('XDG_STATE_HOME', $Env:XDG_STATE_HOME, 'User')
[Environment]::SetEnvironmentVariable('XDG_CACHE_HOME', $Env:XDG_CACHE_HOME, 'User')
