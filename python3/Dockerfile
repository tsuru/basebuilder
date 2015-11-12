# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# this file describes how to build tsuru python3 image
# to run it:
# 1 - tsuru-admin platform-add python3 -d https://raw.github.com/tsuru/basebuilder/master/python3/Dockerfile

from	ubuntu-debootstrap:14.04
run     locale-gen en_US.UTF-8
env	LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive
run	apt-get update && apt-get install sudo wget -y
run	wget https://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz
run	mkdir /var/lib/tsuru
run	tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	rm basebuilder.tar.gz
run	cp /var/lib/tsuru/python3/deploy /var/lib/tsuru
run	/var/lib/tsuru/base/install
run	add-apt-repository ppa:fkrull/deadsnakes -y
run	apt-get update
run	apt-get install python3.4 python3.4-dev -y --force-yes
run	rm -f /usr/bin/python3
run	ln -s /usr/bin/python3.4 /usr/bin/python3
run	ln -s /usr/bin/python3.4 /usr/bin/python
run	wget -qO - https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python3
