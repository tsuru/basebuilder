#!/bin/bash -el

# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

function add_platform() {
	platform=$1
	echo "adding platform $platform..."
	output_file="/tmp/platform-update-${platform}"
	set +e
	tsuru-admin platform-add $platform -d https://raw.githubusercontent.com/tsuru/basebuilder/master/${platform}/Dockerfile | tee $output_file
	result=$?
	set -e
	if [[ $result != 0 ]]; then
		if [[ $(tail -n1 $output_file) != "Error: Duplicate platform" ]]; then
			echo "error adding platform $platform"
			exit $result
		fi
	fi
}

function test_platform() {
	platform=$1
	app_name=app-${platform}
	app_dir=/tmp/${app_name}
	echo "testing platform ${platform} with app ${app_name}..."

	if [ -d ${app_dir} ]
	then
		rm -rf ${app_dir}
	fi

	mkdir ${app_dir}
	git init ${app_dir}
	cp -r /tmp/basebuilder/examples/${platform}/* ${app_dir}
	git --git-dir=${app_dir}/.git --work-tree=${app_dir} add ${app_dir}/*
	git --git-dir=${app_dir}/.git --work-tree=${app_dir} commit -m "add files"

	tsuru app-create ${app_name} ${platform} -o theonepool
	git --git-dir=${app_dir}/.git --work-tree=${app_dir} push git@localhost:${app_name}.git master

	host=`tsuru app-info -a ${app_name} | grep Address | awk '{print $2}'`

	set +e
	for i in `seq 1 5`
	do
		output=`curl -m 5 -fsSNH "Host: ${host}" localhost`
		if [ $? == 0 ]
		then
			break
		fi
		sleep 5
	done
	msg=`echo $output | grep -q "Hello world from tsuru" || echo "ERROR: Platform $platform - Wrong output: $output"`
	set -e

	tsuru app-remove -ya ${app_name}

	if [ "$msg" != "" ]
	then
		echo >&2 $msg
		exit 1
	fi
}

function clone_basebuilder() {
	if [ -d $1 ]
	then
		rm -rf $1
	fi
	git clone https://github.com/tsuru/basebuilder.git $1
	git config --global user.email just_testing@tsuru.io
	git config --global user.name "Tsuru Platform Tests"
}

function clean_tsuru_now() {
	tsuru app-remove -ya tsuru-dashboard 2>/dev/null
	mongo tsurudb --eval 'db.platforms.remove({_id: "python"})'
	docker rmi -f tsuru/python 2>/dev/null
}

export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get install curl -qqy

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export DOCKER_HOST="tcp://127.0.0.1:4243"

case $1 in
	post_receive)
        hook_url="https://raw.github.com/tsuru/tsuru/master/misc/git-hooks/post-receive"
        hook_name="post-receive"
		;;
	pre_receive_swift)
		hook_url="https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.swift"
        hook_name="pre-receive"
        envs=('AUTH_PARAMS="${SWIFT_AUTH_PARAMS}"' 'CONTAINER_NAME=${SWIFT_CONTAINER_NAME}' 'CDN_URL=${SWIFT_CDN_URL}')
		;;
	pre_receive_s3)
		hook_url="https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.s3cmd"
        hook_name="pre-receive"
        envs=('BUCKET_NAME=$S3_BUCKET_NAME')
        export AWS_ACCESS_KEY=$AWS_ACCESS_KEY
        export AWS_SECRET_KEY=$AWS_SECRET_KEY
		;;
esac

if [[ "$1" != "pre_receive_archive" ]]; then
    echo "Configuring gandalf mode..."
    hook_dir=/home/git/bare-template/hooks
    sudo rm -rf $hook_dir
    sudo mkdir -p $hook_dir
    sudo curl -sSL ${hook_url} -o ${hook_dir}/${hook_name}
    sudo chmod +x ${hook_dir}/${hook_name}
    echo export ${envs[@]} | sudo tee -a ~git/.bash_profile > /dev/null
    echo "Done configuring gandalf mode!"
fi

set +e
clean_tsuru_now
set -e

clone_basebuilder /tmp/basebuilder
echo -e "Host localhost\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

platforms="java nodejs php python python3 ruby static cordova play iojs go"

for platform in $platforms
do
	add_platform $platform
	test_platform $platform
done

rm -rf /tmp/basebuilder
rm -rf /tmp/app-*
