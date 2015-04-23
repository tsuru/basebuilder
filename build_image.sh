#!/bin/bash -el

# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Script to build docker image using Dockerfile.template
#
# Usage: ./build_image.sh <image_name>
#
# There should be a directory named <image_name> containing
# only the hooks you wish to override from base
#

IMAGE_NAME=$1
BUILD_DIR=/tmp/image_build/${IMAGE_NAME}_$$
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Building $DIR/$IMAGE_NAME in $BUILD_DIR..."

mkdir -p $BUILD_DIR
cp -a $DIR/* $BUILD_DIR
sed -e "s/{{IMAGE_NAME}}/${IMAGE_NAME}/" $DIR/Dockerfile.template > $BUILD_DIR/Dockerfile
docker build -t "tsuru/$IMAGE_NAME" $BUILD_DIR
rm -rf $BUILD_DIR
