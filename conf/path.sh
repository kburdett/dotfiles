#!/bin/bash

case $(uname -s) in
    Darwin)
        # add brew base path, if present
        if [[ $(command -v brew 2>/dev/null) ]]; then
            export PATH="$(brew --prefix)/bin:$PATH"
        fi
        ;;
    MINGW32_NT*)
        # move Windows VIM and GIT to the front of the path
        export PATH="/c/Program Files (x86)/Git/bin:$PATH"
        ;;
    MINGW64_NT*)
        # move Windows VIM to the front of the path
        export PATH="/c/Program Files (x86)/Git/bin:$PATH"
        ;;
    CYGWIN_NT*)
        # any cygwin adjustments?
        ;;
esac
