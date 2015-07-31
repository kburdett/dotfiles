#!/bin/bash

echo "Configuring keychain credential helper..."
git config --system credential.helper osxkeychain

echo "Configuring autoclrf..."
git config --system core.autocrlf "true"

echo "Configuring Beyond Compare 4"
git config --system diff.tool bc3
git config --system merge.tool bc3
git config --system mergetool.bc3 trustExitCode true
