#!/bin/bash -el
SOURCE_DIR=/var/lib/tsuru
PLATFORM=$1

# Cleanup environment removing all except needed platform from /var/lib/tsuru
cd ${SOURCE_DIR}

# Remove files + Self destruction
find . -maxdepth 1 -type d | grep -vP "^\.$|\.\/base|\.\/${PLATFORM}" | xargs rm -rf
rm Makefile README.* .gitignore $0

# Cleaning up environment
apt-get autoremove -y --force-yes
apt-get clean -y --force-yes
rm -rf /var/cache/apt/archives/*.deb
rm -rf /var/lib/apt/lists/*
rm -rf /root/*
rm -rf /tmp/*
rm -rf /usr/share/doc
rm -rf /usr/shar/man
