# this file describes how to build tsuru php53 image
# to run it:
# 1- install docker
# 2- run: $ docker build -no-cache -t tsuru/php53 https://github.com/7IN0-labs/basebuilder/master/php53/Dockerfile

from    ubuntu:12.04
run	apt-get update
run	apt-get install wget -y --force-yes
run	mkdir /var/lib/tsuru
run	wget --no-check-certificate https://github.com/7IN0-labs/basebuilder/tarball/master -O basebuilder.tar.gz
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	rm basebuilder.tar.gz
run rm /var/lib/tsuru/so_dependencies
run cp /var/lib/tsuru/php53/so_dependencies /var/lib/tsuru
run	cp /var/lib/tsuru/php53/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/php53/start /var/lib/tsuru
run	/var/lib/tsuru/php53/install
run	/var/lib/tsuru/php53/setup
