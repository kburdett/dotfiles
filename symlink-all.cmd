set DIR=%~dp0

rem bash setup
del %USERPROFILE%\.bash_profile
del %USERPROFILE%\.inputrc
mklink  %USERPROFILE%\.bash_profile %DIR%bash_profile
mklink  %USERPROFILE%\.inputrc %DIR%inputrc

rem vim setup
del %USERPROFILE%\_vimrc
del %USERPROFILE%\_gvimrc
rmdir %USERPROFILE%\vimfiles
mklink  %USERPROFILE%\_vimrc %DIR%vimrc
mklink  %USERPROFILE%\_gvimrc %DIR%gvimrc
mklink /d %USERPROFILE%\vimfiles %DIR%vim

rem git setup
del %USERPROFILE%\.gitconfig
del %USERPROFILE%\.gitignore
mklink  %USERPROFILE%\.gitconfig %DIR%gitconfig
mklink  %USERPROFILE%\.gitignore %DIR%gitignore
