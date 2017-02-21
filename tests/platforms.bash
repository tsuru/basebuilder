#!/bin/bash -el

# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

if [ -f /vagrant/.env ]
then
	source /vagrant/.env
fi

function add_platform() {
	platform=$1
	echo "adding platform $platform..."
	output_file="/tmp/platform-update-${platform}"
	set +e
	tsuru-admin platform-add $platform | tee $output_file
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

	tsuru app-create ${app_name} ${platform} -o theonepool -t admin

	echo "Running deploy with git push..."
	git --git-dir=${app_dir}/.git --work-tree=${app_dir} push git@localhost:${app_name}.git master

	echo "Running deploy with app-deploy..."
	pushd ${app_dir}; tsuru app-deploy -a ${app_name} .; popd

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
	tsuru-admin platform-remove -y python 2>/dev/null
}

function tsuru_login {
	yes $2 | tsuru login $1
}

export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get install curl -qqy

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export DOCKER_HOST="tcp://127.0.0.1:4243"

tsuru_login admin@example.com admin123

set +e
clean_tsuru_now
set -e

clone_basebuilder /tmp/basebuilder
echo -e "Host localhost\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

platforms="static java nodejs php python python3 ruby cordova play go elixir buildpack"

for platform in $platforms
do
	add_platform $platform
	test_platform $platform
done

rm -rf /tmp/basebuilder
rm -rf /tmp/app-*
