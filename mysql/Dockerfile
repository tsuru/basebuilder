# this file describes how to build tsuru mysql image
# to run it:
# 1- install docker
# 2- run wget https://raw.github.com/dotcloud/docker/v0.1.6/contrib/docker-build/docker-build && python docker-build <user>/mysql < Dockerfile
# ATTENTION:
# you should run your container using this image with the following command:
# docker run -t -p 3306 mysqlimage mysqld_safe
# you should also change the default environments variables values set here, e.g.: ROOT_PASSWORD and MYSQL_USER_*
from	base:ubuntu-quantal
run	apt-get install wget -y --force-yes
run	wget http://github.com/flaviamissi/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
env	ROOT_PASSWORD root
run	/var/lib/tsuru/mysql/install
run	/var/lib/tsuru/mysql/setup
