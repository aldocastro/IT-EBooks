#!/bin/sh
set -e

xctool -workspace IT-Ebooks.xcworkspace -scheme IT-Ebooks
xctool test -workspace IT-Ebooks.xcworkspace -scheme IT-EbooksTests