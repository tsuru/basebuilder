# -*- coding: utf-8 -*-
import os
import shutil
import pwd

class Frontend(object):
    def __init__(self, configuration, application):
        self.configuration = configuration
        self.application = application

    def get_packages(self):
        return []


class Apache(Frontend):
    def get_packages(self):
        return ['apache2']

    def configure(self, interpretor=None):
        # Set apache virtual host
        vhost_directory = '/etc/apache2/sites-enabled'
        map(os.unlink, [os.path.join(vhost_directory, f) for f in os.listdir(vhost_directory)])
        shutil.copyfile(self.get_vhost_filepath(), os.path.join(vhost_directory, 'tsuru-vhost.conf'))

        # Empty `ports.conf` file
        open('/etc/apache2/ports.conf', 'w').close()

        # Set Apache environment variables accessible when running though cmd
        with open('/etc/profile', 'a') as profile_file:
            profile_file.write(
                "\n"
                "export APACHE_RUN_USER=%s\n"
                "export APACHE_RUN_GROUP=%s\n"
                "export APACHE_PID_FILE=/var/run/apache2/apache2.pid\n"
                "export APACHE_RUN_DIR=/var/run/apache2\n"
                "export APACHE_LOCK_DIR=/var/lock/apache2\n"
                "export APACHE_LOG_DIR=/var/log/apache2\n"
                 % (self.application.get('user'), self.application.get('user'))
            )

        # Clean log files
        logs_directory = '/var/log/apache2'
        if not os.path.exists(logs_directory):
            os.makedirs(logs_directory)

        map(os.unlink, [os.path.join(logs_directory, f) for f in os.listdir(logs_directory)])
        for log_file in ['access.log', 'error.log']:
            log_file_path = os.path.join(logs_directory, log_file)
            open(log_file_path, 'a').close()

        # Configure modules if needed
        for module in self.configuration.get('modules', []):
            os.system('a2enmod %s' % module)

        # Fix user rights
        os.system('chown -R %s /var/run/apache2 /var/log/apache2 /var/lock/apache2' % self.application.get('user'))

    def get_vhost_filepath(self):
        if 'vhost_file' in self.configuration:
            return os.path.join(self.application.get('directory'), self.configuration.get('vhost_file'))

        return self.get_default_vhost_filepath()

    def get_default_vhost_filepath(self):
        return os.path.join(self.application.get('source_directory'), 'php', 'frontend', 'apache', 'vhost.conf')

    def get_startup_cmd(self):
        return '/usr/sbin/apache2 -d /etc/apache2 -k start -DNO_DETACH'


class ApacheModPHP(Apache):
    def get_default_vhost_filepath(self):
        return os.path.join(self.application.get('source_directory'), 'php', 'frontend', 'apache-mod-php', 'vhost.conf')

    def get_packages(self):
        return ['apache2', 'php5']

frontends = {
    'apache-mod-php': ApacheModPHP
}
