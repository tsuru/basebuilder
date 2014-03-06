!#/bin/bash
SOURCE_DIR=/var/lib/tsuru
PLATFORM=$2

# Cleanup environment removing all except needed platform from /var/lib/tsuru
cd ${SOURCE_DIR}

rm -v Makefile README.* .gitignore
for i in $(find -type d ! -path ${PLATFORM} ! -path base); do rm -rfv ${i}; done

# Self destruction
rm -v $0
