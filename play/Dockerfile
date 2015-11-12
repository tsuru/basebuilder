# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# this file describes how to build tsuru play image
# to run it:
# 1 - tsuru-admin platform-add play -d https://raw.github.com/tsuru/basebuilder/master/play/Dockerfile

from ubuntu-debootstrap:14.04
run locale-gen en_US.UTF-8
env LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive
run apt-get update && apt-get install wget sudo -y --force-yes
run wget https://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz
run mkdir /var/lib/tsuru
run tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run rm basebuilder.tar.gz
run cp /var/lib/tsuru/play/deploy /var/lib/tsuru
run chmod -R 777 /var/lib/tsuru
run /var/lib/tsuru/play/install
