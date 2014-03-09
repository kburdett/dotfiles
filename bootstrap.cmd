@echo off
@setlocal enabledelayedexpansion enableextensions
set dir=%~dp0

rem link . files
for %%f in (%dir%*.symlink) do (
        set target=%USERPROFILE%\.%%~nf
        del !target!
        mklink !target! %%f
        echo Linked %%f at !target!
        )

rem link _ files
rem NOTE: This is only used by Windows VIM/GVIM, it is a duplicate link, but Cygwin still uses the . files
for %%f in (%dir%*vim*.symlink) do (
        set target=%USERPROFILE%\_%%~nf
        del !target!
        mklink !target! %%f
        echo Linked %%f at !target!
        )

rem link . directories
for /D %%d in (%dir%*.symlink) do (
        set target=%USERPROFILE%\.%%~nd
        rmdir /Q /S !target!
        mklink /d !target! %%d
        echo Linked directory %%d at !target!
        )

rem link vimfiles
rem NOTE: This is only used by Windows VIM/GVIM, it is a duplicate link, but Cygwin still uses the . directory
set target=%USERPROFILE%\vimfiles
set source=%dir%vim.symlink
rmdir /Q /S !target!
mklink /d !target! !source!
echo Linked directory !source! at !target!

endlocal
