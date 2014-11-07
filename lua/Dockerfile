from ubuntu:14.04
run	apt-get update
run	apt-get install wget -y --force-yes
run	wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run curl -R -O http://www.lua.org/ftp/lua-5.2.3.tar.gz
run tar zxf lua-5.2.3.tar.gz
run cd lua-5.2.3
run make linux test