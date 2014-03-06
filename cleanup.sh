#!/bin/bash -el
SOURCE_DIR=/var/lib/tsuru
PLATFORM=$2

# Cleanup environment removing all except needed platform from /var/lib/tsuru
cd ${SOURCE_DIR}

rm -v Makefile README.* .gitignore
rm -rfv $(find . -maxdepth 1 -type d | egrep -v './base|./php')
ls -la ${SOURCE_DIR}

# Self destruction
rm -v $0
