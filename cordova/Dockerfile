# this file describes how to build tsuru cordova image
# to run it:
# 1 - tsuru-admin platform-add cordova -d https://raw.github.com/tsuru/basebuilder/master/cordova/Dockerfile

from	ubuntu:14.04
run	apt-get update
run	apt-get install wget -y --force-yes
run	wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	cp /var/lib/tsuru/cordova/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/base/start /var/lib/tsuru
run	/var/lib/tsuru/cordova/install
run	/var/lib/tsuru/cordova/setup
