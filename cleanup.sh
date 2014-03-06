#!/bin/bash -el
SOURCE_DIR=/var/lib/tsuru
PLATFORM=$2

# Cleanup environment removing all except needed platform from /var/lib/tsuru
cd ${SOURCE_DIR}

rm -v Makefile README.* .gitignore
x=$(/usr/bin/find -type d ! -path ${PLATFORM} ! -path base)
echo "START DELETE: ${x} END DELETE"
ls -la ${SOURCE_DIR} --color=auto

# Self destruction
rm -v $0
