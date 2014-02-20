# this file describes how to build tsuru php image
# to run it:
# 1- install docker
# 2- run: $ docker build -no-cache -t tsuru/php https://github.com/guestisp/basebuilder/master/php/Dockerfile

from	base:ubuntu-quantal

#run     apt-get -y install fuse

run     apt-get install wget -y --force-yes
run	    mkdir /var/lib/tsuru
run     wget --no-check-certificate https://github.com/guestisp/basebuilder/tarball/master -O basebuilder.tar.gz
run     tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run     rm basebuilder.tar.gz
run     cp /var/lib/tsuru/php/deploy /var/lib/tsuru
run     cp /var/lib/tsuru/php/restart /var/lib/tsuru
run     cp /var/lib/tsuru/php/start /var/lib/tsuru
run     cp /var/lib/tsuru/php/create_fpm_envs /var/lib/tsuru
run     /var/lib/tsuru/php/install
run     /var/lib/tsuru/php/setup
