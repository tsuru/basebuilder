from ubuntu:14.04
run	apt-get update
run	apt-get install make wget -y --force-yes
run	wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate

# install lua
run wget http://www.lua.org/ftp/lua-5.2.3.tar.gz
run tar zxf lua-5.2.3.tar.gz
run cd lua-5.2.3
run make linux test

# install luarocks
run cd ..
wget http://luarocks.org/releases/luarocks-2.2.0.tar.gz
tar zxvpf luarocks-2.2.0.tar.gz
cd luarocks-2.2.0
./configure
make bootstrap;

