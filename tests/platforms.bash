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
	tsuru-admin platform-remove -y python 2>/dev/null
}

function tsuru_login {
	yes $2 | tsuru login $1
}

function install_swift {
	sudo apt-get install python-pip python-dev libxml2-dev libxslt-dev libz-dev -y
	sudo pip install python-swiftclient==2.5.0 python-keystoneclient
}

function install_s3cmd() {
	sudo apt-get install s3cmd python-magic -y
	cat > /tmp/s3cfg <<END
[default]
access_key = ${AWS_ACCESS_KEY}
bucket_location = US
cloudfront_host = cloudfront.amazonaws.com
default_mime_type = binary/octet-stream
delete_removed = False
dry_run = False
enable_multipart = True
encoding = ANSI_X3.4-1968
encrypt = False
follow_symlinks = False
force = False
get_continue = False
gpg_command = /usr/bin/gpg
gpg_decrypt = %(gpg_command)s -d --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s
gpg_encrypt = %(gpg_command)s -c --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s
gpg_passphrase =
guess_mime_type = True
host_base = s3.amazonaws.com
host_bucket = %(bucket)s.s3.amazonaws.com
human_readable_sizes = False
invalidate_on_cf = False
list_md5 = False
log_target_prefix =
mime_type =
multipart_chunk_size_mb = 15
preserve_attrs = True
progress_meter = True
proxy_host =
proxy_port = 0
recursive = False
recv_chunk = 4096
reduced_redundancy = False
secret_key = ${AWS_SECRET_KEY}
send_chunk = 4096
simpledb_host = sdb.amazonaws.com
skip_existing = False
socket_timeout = 300
urlencoding_mode = normal
use_https = True
verbosity = WARNING
website_endpoint = http://%(bucket)s.s3-website-%(location)s.amazonaws.com/
website_error =
website_index = index.html
END
	sudo mv /tmp/s3cfg ~git/.s3cfg
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
		envs=("AUTH_PARAMS=\"${SWIFT_AUTH_PARAMS}\"" "CONTAINER_NAME=${SWIFT_CONTAINER_NAME}" "CDN_URL=${SWIFT_CDN_URL}")
		install_swift
		;;
	pre_receive_s3)
		hook_url="https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.s3cmd"
		hook_name="pre-receive"
		envs=("BUCKET_NAME=$S3_BUCKET_NAME")
		install_s3cmd
		;;
esac

if [[ "$1" != "pre_receive_archive" ]]; then
	echo "Configuring gandalf mode..."
	hook_dir=/home/git/bare-template/hooks
	sudo rm -rf $hook_dir
	sudo mkdir -p $hook_dir
	sudo curl -sSL ${hook_url} -o ${hook_dir}/${hook_name}
	sudo chmod +x ${hook_dir}/${hook_name}
	echo export ${envs[@]} | sudo tee -a ~git/.bash_profile
	echo "Done configuring gandalf mode!"
fi

tsuru_login admin@example.com admin123

set +e
clean_tsuru_now
set -e

clone_basebuilder /tmp/basebuilder
echo -e "Host localhost\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

platforms="java nodejs php python python3 ruby static cordova play go"

for platform in $platforms
do
	add_platform $platform
	test_platform $platform
done

rm -rf /tmp/basebuilder
rm -rf /tmp/app-*
