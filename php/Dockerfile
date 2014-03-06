# this file describes how to build tsuru php image
# to run it:
# 1- install docker
# 2- run: $ docker build -no-cache -t tsuru/php https://github.com/guestisp/basebuilder/master/php/Dockerfile

from	base:ubuntu-quantal

env     DEBIAN_FRONTEND noninteractive

add     dev-fuse.tgz /dev/
run     apt-get -y install fuse

run     apt-get install wget curl -y --force-yes

run	    mkdir /var/lib/tsuru

run     wget --no-check-certificate https://github.com/guestisp/basebuilder/tarball/master -O basebuilder.tar.gz
run     tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run     rm basebuilder.tar.gz
run     /var/lib/tsuru/cleanup.sh php

run     mv /var/lib/tsuru/base/restart /var/lib/tsuru
run     mv /var/lib/tsuru/base/start /var/lib/tsuru

run     mv /var/lib/tsuru/php/deploy /var/lib/tsuru
run     mv /var/lib/tsuru/php/php5-fpm /var/lib/tsuru
run     mv /var/lib/tsuru/php/create_fpm_envs.py /var/lib/tsuru

run     /var/lib/tsuru/php/install
run     /var/lib/tsuru/php/setup
