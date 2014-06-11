# this file describes how to build tsuru nodejs image
# to run it:
# 1- install docker
# 2- run wget https://raw.github.com/dotcloud/docker/v0.1.6/contrib/docker-build/docker-build && python docker-build <user>/base < Dockerfile

from	ubuntu:14.04
run	apt-get update
run	apt-get install wget -y --force-yes
run	wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	cp /var/lib/tsuru/nodejs/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/base/restart /var/lib/tsuru
run	cp /var/lib/tsuru/base/start /var/lib/tsuru
run	/var/lib/tsuru/base/install
run	apt-get install nodejs npm nodejs-legacy -y
run	/var/lib/tsuru/base/setup
