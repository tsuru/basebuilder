This repository serve as a starter to build platform specific images for tsuru docker provision.

Why this image?
---------------

Tsuru will need to perform some actions in the containers created using docker.
For that, it will need ssh access in the created containers. So if you want to build
your own platform base image you would have to provide this by yourself. This is one
of the matters this repository aims to solve.

In order to create a base image for a platform (let's say you wanna add support for php, for instance)
you just clone this repository and implement the platform specific installations and
configurations on the placeholders. You won't have to reimplement tsuru specific stuff.


Hooks explained
---------------


This image has two implemented scripts:

 - add_key
 - base_requirements

And another two placeholders for your use:

 - platform_install
 - platform_setup


The `add_key` hook receives the ssh public key of the machine and user that is
running tsuru. This is for allowing tsuru to run commands in the containers (via `tsuru run`).
The `base_requirements` script is for installing OS requirements, this is not
platform dependent, then it serves for any kind of application.

The placeholders are just empty files that you'll have to implement in order
to create a platform specific image.


Extra hooks
-----------

You might be wondering what happens if you add extra hooks on your platform image.
Tsuru won't call any hooks other than those listed here, if you want to better split
your scripts, you'll have to execute them yourself inside the hooks described above.
(At least for now...)
