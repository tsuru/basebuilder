#!/bin/bash -el
SOURCE_DIR=/var/lib/tsuru
PLATFORM=$1

# Cleanup environment removing all except needed platform from /var/lib/tsuru
cd ${SOURCE_DIR}

# Remove files + Self destruction
rm -f Makefile README.* .gitignore
rm -vrf `find . -maxdepth 1 -type d | grep -vP "./base|./${PLATFORM}"` 
ls -la ${SOURCE_DIR}
