#!/bin/bash

echo "Configuring git credential winstore..."
git config --system credential.helper "/c/devtools/git-credential-winstore.exe"

echo "Configuring autoclrf..."
git config --system core.autocrlf "true"

echo "Configuring Beyond Compare 4"
git config --system diff.tool bc3
git config --system difftool.bc3.path "c:/Program Files (x86)/Beyond Compare 4/bcomp.exe"
git config --system merge.tool bc3
git config --system mergetool.bc3.path "c:/Program Files (x86)/Beyond Compare 4/bcomp.exe"
