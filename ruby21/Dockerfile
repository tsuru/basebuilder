# this file describes how to build tsuru ruby 2.1 image
# to run it:
# 1- install docker
# 2- run: $ docker build -t tsuru/ruby21 https://raw.github.com/tsuru/basebuilder/master/ruby21/Dockerfile

from	ubuntu:14.04
run	apt-get update
run	DEBIAN_FRONTEND=noninteractive apt-get install wget -y --force-yes
run	wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	cp /var/lib/tsuru/ruby21/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/base/start /var/lib/tsuru
run	/var/lib/tsuru/ruby21/install
