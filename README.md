This repository has the scripts used to build tsuru's base docker image.
Keep reading for better understanding what that image does and how to create
your own image for tsuru to use.


Why this image?
---------------

Tsuru will need to perform some actions in the containers created by docker.
This image have a built-in delpoyment script, which will also run the
requirements.apt file (so_requirements file). So if you want to build your own
platform base image you would have to provide this by yourself. This is one of
the matters this repository aims to solve.

In order to create a base image for a platform (let's say you wanna add
support for php, for instance) you'll use tsuru's base image as your base
image, this will give you the hooks tsuru will need to work properly.


Hooks explained
---------------

This image has two implemented scripts:

 - deploy
 - so_dependencies

The `deploy` hook receives the application git read-only url. It will clone
the repository into the $CURRENT_DIR environment defined in the config file.
If this directory already exists, the script will simply run a `git pull`
inside $CURRENT_DIR. This script will also call the `so_dependencies` function,
defined in the `so_dependencies` file.
The `so_dependencies` script is for installing OS requirements, this is not
platform dependent, then it serves for any kind of application.

Making your own docker image
----------------------------

To add support for platforms tsuru does not have built-in support, one must
create images. Simple create a container using tsuru base image and install
everything your platform needs to run. When you're done, commit and push the
image to docker registry. You might have to change some of the default scripts,
for example, if you need to search platform specific dependencies (and you
probably will), you'll have to call your custom dependencies seeker in the
deploy script, which is the only one called directly by tsuru in deployment
time.
