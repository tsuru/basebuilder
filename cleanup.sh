#!/bin/bash -el
SOURCE_DIR=/var/lib/tsuru
PLATFORM=$1

# Cleanup environment removing all except needed platform from /var/lib/tsuru
cd ${SOURCE_DIR}

find . -maxdepth 1 -type d | grep -vP "./base|./${PLATFORM}" | xargs rm -rfv
ls -la ${SOURCE_DIR}

# Remove files + Self destruction
rm -v Makefile README.* .gitignore cleanup.sh
