# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# this file describes how to build tsuru cordova image
# to run it:
# 1 - tsuru-admin platform-add cordova -d https://raw.github.com/tsuru/basebuilder/master/cordova/Dockerfile

from	ubuntu:14.04
run     locale-gen en_US.UTF-8
env     LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
run	apt-get update
run	apt-get install wget -y --force-yes
run	wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	rm basebuilder.tar.gz
run	cp /var/lib/tsuru/cordova/deploy /var/lib/tsuru
run	cp /var/lib/tsuru/base/start /var/lib/tsuru
run	/var/lib/tsuru/cordova/install
