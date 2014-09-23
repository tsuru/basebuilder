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

tsuru will look for two scripts to be available inside the platform image:

 - /var/lib/tsuru/start
 - /var/lib/tsuru/deploy

You should make sure these scripts are added by your Dockerfile, in a similar
fashion to how it's done in the example platforms.

The `deploy` script is called by tsuru when creating an image for your
application. It's responsible for downloading the source code and installing
possible dependencies.

It's highly recommended for your platform's deploy script to source the
contents of the `/base/deploy` script. This script already handles downloading
the source code and installing OS dependencies described by the
`requirements.apt` file.

The `start` script is called by tsuru to start your application on an image
previously built with the `deploy` script.

Currently all of our platforms rely on **circus** to run the application based
on a the contents of a `Procfile` present in the application. It's recommended
that a new platform use circus in the same way, therefore avoiding the need to
change the start script from the one already available at `/base/start`.

Using circus is useful since it already handles parsing the Procfile, log
forwarding to tsuru and restarting the process if it dies for some reason. You
can customize your platform's circus.ini from the one available in
`/utils/circus.ini` by making sure your Dockerfile writes your file to
`/etc/circus/circus.ini`.

