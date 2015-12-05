#!/usr/bin/env sh
set -e

xctool -workspace IT-Ebooks.xcworkspace -scheme IT-Ebooks -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
xctool test -workspace IT-Ebooks.xcworkspace -scheme IT-EbooksTests -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO