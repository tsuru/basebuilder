#!/bin/bash -el

# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

if [ -f /vagrant/.env ]
then
	source /vagrant/.env
fi

args=""

case $1 in
	pre_receive_archive)
		args=("pre_receive_archive")
		;;
	pre_receive_swift)
		args=(--hook-url https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.swift --hook-name pre-receive --env AUTH_PARAMS "${SWIFT_AUTH_PARAMS}" --env CONTAINER_NAME ${SWIFT_CONTAINER_NAME} --env CDN_URL ${SWIFT_CDN_URL})
		;;
	pre_receive_s3)
		args=(--hook-url https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.s3cmd --hook-name pre-receive --env BUCKET_NAME $S3_BUCKET_NAME --aws-access-key $AWS_ACCESS_KEY --aws-secret-key $AWS_SECRET_KEY)
		;;
esac

sudo -iu $SUDO_USER /vagrant/platforms.bash "${args[@]}"
