# you should run your container using this image with the following command:
# docker run -t -p 3306 mysqlimage mysqld_safe
from	base:ubuntu-quantal
run		apt-get install wget -y --force-yes
run		wget http://github.com/flaviamissi/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run		mkdir /var/lib/tsuru
run		tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run		/var/lib/tsuru/mysql/install
run		/var/lib/tsuru/mysql/setup
