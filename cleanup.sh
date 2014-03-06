#!/bin/bash -el
SOURCE_DIR=/var/lib/tsuru
PLATFORM=$2

# Cleanup environment removing all except needed platform from /var/lib/tsuru
cd ${SOURCE_DIR}

rm -v Makefile README.* .gitignore
find -type d ! -path ${PLATFORM} ! -path base -exec rm -rfv {} \;
ls -la ${SOURCE_DIR} --color=auto

# Self destruction
rm -v $0
