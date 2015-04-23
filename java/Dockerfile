# this file describes how to build tsuru java image
# to run it:
# 1- run: $ tsuru-admin platform-add java -d https://raw.github.com/tsuru/basebuilder/master/java/Dockerfile

from	ubuntu:14.04
env     locale-gen en_US.UTF-8
env     LANG en_US.UTF-8
env     LANGUAGE en_US:en
env     LC_ALL en_US.UTF-8
run	apt-get update
run	apt-get install wget -y --force-yes
run	wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	cp /var/lib/tsuru/java/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/java/start /var/lib/tsuru
run	/var/lib/tsuru/java/install
