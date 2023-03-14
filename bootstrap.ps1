$XdgConfigDir = $Env:LOCALAPPDATA
$HomeDir = $Env:USERPROFILE

function Link-All {

    param (
        [string]$Source,
        [string]$Dest
    )

    foreach ($Child in Get-ChildItem -Path $Source -Name -Force) {
        $SourceFqn = Join-Path -Path $Source -ChildPath $Child
        $TargetFqn = Join-Path -Path $Dest -ChildPath $Child

        Write-Host "Symlinking $Child from ""$SourceFqn"" to ""$TargetFqn"""
        New-Item -ItemType SymbolicLink -Path $SourceFqn -Target $TargetFqn -Force
    }
}

$DotfilesDir = Split-Path -parent $PSCommandPath

Write-Host "Deploying XDG configurations to ""$XdgConfigDir"""
$XdgDotfilesDir = Join-Path -Path $DotfilesDir -ChildPath "xdg"
Link-All -Source $XdgDotfilesDir -Dest $XdgConfigDir

Write-Host "Deploying dotfiles to ""$HomeDir"""
$HomeDotfilesDir = Join-Path -Path $DotfilesDir -ChildPath "home"
Link-All -Source $HomeDotfilesDir -Dest $HomeDir
