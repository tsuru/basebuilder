This repository has the scripts used to build tsuru's docker images.
Keep reading for better understanding what that image does and how to create
your own image for using at tsuru.


Why this image?
---------------

Tsuru performs some actions in the containers created by docker.
Each image has a built-in deployment script, which also runs the
requirements.apt file (`so_requirements` file). If none of the default
images attends your needs, you have to customize an image.
This repository aims to make this process easier.

In order to create a base image for a platform (let's say you wanna add
support for php, for instance) you can use tsuru's base image as your base
image, and addapt to your needs. Implementing the hooks (described below)
will allow tsuru to run php apps properly.


Hooks explained
---------------

Images must have two scripts (or hooks):

 - deploy
 - so_dependencies

The `deploy` hook receives the application git read-only url. It will clone
the repository into the `$CURRENT_DIR` environment defined in the config file.
If the directory already exists, the script will simply run a `git pull`
inside `$CURRENT_DIR`. This script will also call the `so_dependencies` function,
defined in the `so_dependencies` file.
The `so_dependencies` script is intended to install OS requirements. It is not
platform dependent and, therefore, can be used for any kind of application.

Making your own docker image
----------------------------

To add support for platforms tsuru does not have built-in support, one must
create images. Simply create a container using tsuru base image and install
everything your platform needs to run. When you're done, commit and push the
image to docker registry. You might have to change some of the default scripts.
For example, if you need to search platform specific dependencies (and you
will probably need), you'll have to call your custom dependencies seeker in the
deploy script, which is the only one called directly by tsuru in deployment
time.
