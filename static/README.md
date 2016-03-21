# Static platform

The static platform provides a nginx setup that serves anything that is in the
application directory. A simple application with just an index.html file can be
easily deployed to tsuru.

## Customizing nginx configuration

It's possible to customize nginx configuration by simply placing a file named
nginx.conf in the root of the project. The default configuration file is:

	$ cat nginx.conf
	worker_processes 4;
	pid /var/lib/nginx/nginx.pid;
	error_log stderr;

	events {
		worker_connections  1024;
	}

	http {
		include      mime.types;
		default_type application/octet-stream;
		types_hash_max_size 2048;

		sendfile     on;

		keepalive_timeout  65;
		access_log /dev/stdout;

		server {
			listen      8888;
			server_name localhost;

			port_in_redirect off;

			location / {
				root  /home/application/current;
				index index.html index.htm;
			}
		}
	}

A common practice is to copy it and then do some customizations, as it contains
some mandatory directives for proper behavior on tsuru (like ``port_in_redirect
off``).