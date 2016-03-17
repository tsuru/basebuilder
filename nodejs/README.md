# Nodejs platform

The Nodejs platform uses nvm to run your code and you can choose what node
version you want to run it. To define node version you have three ways:

    * .nvmrc
        $ cat .nvmrc
        4.4.0
    * .node-version
        $ cat .node-version
        4.4.0
    * package.json
        $ cat package.json
        ...
        "engines": {
            "node": "4.2.6",
        },
        ...

This file should be in the root of deploy files.

You can also send your node_modules by setting enviroment variable ``KEEP_NODE_MODULES``
