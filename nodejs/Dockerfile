# this file describes how to build tsuru nodejs image
# to run it:
# 1- install docker
# 2- run wget https://raw.github.com/dotcloud/docker/v0.1.6/contrib/docker-build/docker-build && python docker-build <user>/base < Dockerfile

from	base:ubuntu-quantal
run	apt-get install wget -y --force-yes
run	wget http://github.com/flaviamissi/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	cp /var/lib/tsuru/nodejs/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/base/restart /var/lib/tsuru
run	cp /var/lib/tsuru/base/start /var/lib/tsuru
run	/var/lib/tsuru/nodejs/install
run	/var/lib/tsuru/base/setup
