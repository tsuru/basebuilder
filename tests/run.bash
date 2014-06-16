#!/bin/bash -el

args=""

case $1 in
	pre_receive_archive)
		args="--archive-server --hook-url https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.archive-server --hook-name pre-receive"
		;;
esac

sudo -iu vagrant /vagrant/platforms.bash $args
