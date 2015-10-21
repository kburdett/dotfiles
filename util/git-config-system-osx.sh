#!/bin/bash

echo "Configuring keychain credential helper..."
git config --system credential.helper osxkeychain

echo "Configuring autoclrf..."
git config --system core.autocrlf input

echo "Configuring Beyond Compare 4"
# NOTE: using BC3 options per docs http://www.scootersoftware.com/support.php?zz=kb_vcs_osx
git config --system diff.tool bc3
git config --system merge.tool bc3
git config --system mergetool.bc3 trustExitCode true
