#!/usr/bin/env sh
set -ev

xctool -workspace IT-Ebooks.xcworkspace -scheme IT-Ebooks -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
xctool test -workspace IT-Ebooks.xcworkspace -scheme IT-EbooksTests -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO