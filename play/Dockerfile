# this file describes how to build tsuru play image
# to run it:
# 1 - tsuru-admin platform-add play -d https://raw.github.com/tsuru/basebuilder/master/play/Dockerfile

from ubuntu:14.04
run apt-get update
run apt-get install wget -y --force-yes
run wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run mkdir /var/lib/tsuru
run tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run cp /var/lib/tsuru/play/deploy /var/lib/tsuru
run cp /var/lib/tsuru/base/start /var/lib/tsuru
run chmod -R 777 /var/lib/tsuru
run /var/lib/tsuru/play/install
