# Copyright 2015 basebuilder authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

from    progrium/buildstep
run     apt-get update
run     apt-get install wget sudo -y --force-yes
run     wget http://github.com/tsuru/basebuilder/tarball/master -O basebuilder.tar.gz --no-check-certificate
run     mkdir /var/lib/tsuru
run     tar -xvf basebuilder.tar.gz -C /var/lib/tsuru --strip 1
run	rm basebuilder.tar.gz
run     cp /var/lib/tsuru/buildpack/deploy /var/lib/tsuru
run     /var/lib/tsuru/buildpack/install
run     chmod +x /var/lib/tsuru/deploy
