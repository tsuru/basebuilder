This repository has the scripts used to build tsuru's docker images.

Installing platforms
--------------------

Each directory describes a tsuru platform. To add one of these platforms to
your tsuru installation you simply call:

```
$ tsuru-admin platform-add <name> -d https://raw.github.com/tsuru/basebuilder/master/<name>/Dockerfile
```

Creating new platforms
----------------------

The only mandatory file if you're creating a new platform is the Dockerfile.

tsuru will look for one entrypoint during deployment: /var/lib/tsuru/deploy.

You should make sure that this script is added by your Dockerfile, in a similar
fashion to how it's done in the available  platforms.

The `deploy` script is called by tsuru when creating an image for your
application. It's responsible for downloading the source code and installing
possible dependencies.

It's highly recommended for your platform's deploy script to source the
contents of the `/base/deploy` script. This script already handles downloading
the source code and installing OS dependencies described by the
`requirements.apt` file.
