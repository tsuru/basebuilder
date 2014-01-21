# this file describes how to build tsuru php image
# to run it:
# 1- install docker
# 2- run: $ docker build -t tsuru/php https://github.com/guestisp/basebuilder/master/php/Dockerfile

from	base:ubuntu-quantal
run	apt-get install wget -y --force-yes
run	wget https://github.com/guestisp/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	cp /var/lib/tsuru/base/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/base/restart /var/lib/tsuru
run	cp /var/lib/tsuru/base/start /var/lib/tsuru
run	/var/lib/tsuru/php/install
run	/var/lib/tsuru/php/setup
run rm basebuilder.tar.gz
