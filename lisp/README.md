For this platform to work, you will need to add a build hook to tsuru.yml to compile your app, similar to:
```
hooks:
  build:
    - sbcl --dynamic-space-size 4096 --control-stack-size 32 --non-interactive --eval '(ql:quickload "APP_NAME")'
```
