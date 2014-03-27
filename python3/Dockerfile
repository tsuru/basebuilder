# this file describes how to build tsuru python image
# to run it:
# 1- install docker
# 2- run: $ docker build -t tsuru/python https://raw.github.com/tsuru/basebuilder/master/python3/Dockerfile
 
from    base:ubuntu-quantal
run apt-get update
run apt-get install software-properties-common curl wget -y
run wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run mkdir /var/lib/tsuru
run tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run cp /var/lib/tsuru/python3/deploy /var/lib/tsuru
run cp /var/lib/tsuru/base/restart /var/lib/tsuru
run cp /var/lib/tsuru/base/start /var/lib/tsuru
run /var/lib/tsuru/base/install
run /var/lib/tsuru/base/setup
run add-apt-repository ppa:fkrull/deadsnakes -y
run apt-get update
run apt-get install python3.3 -y
run rm /usr/bin/python3
run ln -s /usr/bin/python3.3 /usr/bin/python3
run curl http://python-distribute.org/distribute_setup.py | python3
run curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python3