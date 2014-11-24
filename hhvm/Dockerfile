# this file describes how to build tsuru hhvm image
# to run it:
# 1- install docker
# 2- run: $ docker build -no-cache -t tsuru/hhvm https://raw.githubusercontent.com/tsuru/basebuilder/master/hhvm/Dockerfile

from    ubuntu:14.04
run	apt-get update
run	apt-get install wget -y --force-yes
run	mkdir /var/lib/tsuru
run	wget --no-check-certificate https://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	rm basebuilder.tar.gz
run	cp /var/lib/tsuru/hhvm/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/hhvm/start /var/lib/tsuru
run	/var/lib/tsuru/hhvm/install
run	/var/lib/tsuru/hhvm/setup
