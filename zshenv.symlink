#!/bin/bash

case $(uname -s) in
    Darwin)
        # move /usr/local/bin to the front for brew installed paths
        export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/.cabal/bin
        ;;
    MINGW32_NT*)
        # move Windows VIM and GIT to the front of the path
        export PATH="/c/Program Files (x86)/Vim/vim74:/c/Program Files (x86)/Git/bin:$PATH"
        ;;
    MINGW64_NT*)
        # move Windows VIM to the front of the path
        export PATH="/c/Program Files (x86)/Vim/vim74:$PATH"
        ;;
    CYGWIN_NT*)
        # any cygwin adjustments?
        ;;
esac
