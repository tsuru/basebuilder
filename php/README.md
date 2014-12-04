# PHP platform

The PHP platform is built to be able to manage multiple front-end and interpretors. You can manage them in your `app.yml` configuration file.

```yml
php:
    frontend:
        name: nginx
    interpretor:
        name: hvvm
```

## Front ends

The following frontends are currently supported:
- `apache`: Apache
- `nginx`: Nginx

You can chose between them by setting the `php.frontend.name` parameter:
```yml
php:
    frontend:
        name: apache
```

Each frontend supports options that can be set in the `php.frontend.options` parameters.

### Apache options

- `vhost_file`: The relative path of your Apache virtual host configuration file

### Nginx options

- `vhost_file`: The relative path of your Nginx virtual host configuration file

## Interpretors

The following PHP interpretors are supported:

- `fpm5.4`: PHP 5.4 though PHP-FPM
- `hhvm`: HHVM

You can chose between them by setting the `php.interpretor.name` parameter:
```yml
php:
    interpretor:
        name: fpm5.4
```

These interpretors can also have options configured in the `php.interpretor.options` parameter.

## `fpm5.4` options

- `ini_file`: The relative path of your `php.ini` file in your project, that will replace the default one

## `hhvm` options

- `ini_file`: The relative path of your `php.ini` file used by HHVM

## Backward compatibility

To keep the backward compatibility, there's also a `apache-mod-php` frontend that is in fact the Apache with modphp enabled, that remove the need of an interpretor.
That's currently the default configuration if no parameter is set.
