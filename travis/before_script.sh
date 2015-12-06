#!/usr/bin/env sh
set -ev
brew update
#brew install xctool
brew unlink xctool
brew install xctool --HEAD