# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

from ubuntu:14.04
run locale-gen en_US.UTF-8
env LANG en_US.UTF-8
env LANGUAGE en_US:en
env LC_ALL en_US.UTF-8
run apt-get update
run apt-get install nginx -u
run apt-get install make wget -y --force-yes
run apt-get install lua5.1 luarocks -y
run luarocks install lapis

run wget http://openresty.org/download/ngx_openresty-1.7.2.1.tar.gz
run tar -zxvf ngx_openresty-1.7.2.1.tar.gz
run cd ngx_openresty-1.7.2.1/
run ./configure
run make
run make install
