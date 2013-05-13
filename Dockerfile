# this file describes how to build tsuru base image
# to run it:
# 1- install docker
# 2- run wget https://raw.github.com/dotcloud/docker/v0.1.6/contrib/docker-build/docker-build && python docker-build <user>/base < Dockerfile

from	base:ubuntu-quantal
run		wget https://github.com/flaviamissi/basebuilder/tarball/master -O basebuilder.tar.gz
run		tar -xvf basebuilder.tar.gz
run		mkdir /var/lib/tsuru
run		mv basebuilder/* /var/lib/tsuru
run		/var/lib/tsuru/install
run		/var/lib/tsuru/setup
