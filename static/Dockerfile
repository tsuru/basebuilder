# this file describes how to build tsuru static image
# to run it:
# 1- install docker
# 2- run: $ docker build -t tsuru/static https://raw.github.com/flaviamissi/basebuilder/master/static/Dockerfile

from	base:ubuntu-quantal
run	apt-get install wget -y --force-yes
run	wget http://github.com/flaviamissi/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	cp /var/lib/tsuru/static/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/static/restart /var/lib/tsuru
run	cp /var/lib/tsuru/static/start /var/lib/tsuru
run	/var/lib/tsuru/static/install
run	/var/lib/tsuru/static/setup
