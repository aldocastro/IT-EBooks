#!/usr/bin/env sh
set -ev
brew update
if brew outdated --quiet | grep -qx xctool; then brew upgrade xctool; fi