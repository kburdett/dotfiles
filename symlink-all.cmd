set DIR=%~dp0

del %USERPROFILE%\_vimrc
del %USERPROFILE%\_gvimrc
rmdir %USERPROFILE%\vimfiles
del %USERPROFILE%\.gitconfig
del %USERPROFILE%\.gitignore

mklink  %USERPROFILE%\_vimrc %DIR%vimrc
mklink  %USERPROFILE%\_gvimrc %DIR%gvimrc
mklink /d %USERPROFILE%\vimfiles %DIR%vim
mklink  %USERPROFILE%\.gitconfig %DIR%gitconfig
mklink  %USERPROFILE%\.gitignore %DIR%gitignore
