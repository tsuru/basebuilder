# -*- coding: utf-8 -*-
import os
import shutil
from utils import replace

class Interpretor(object):
    def __init__(self, configuration, application):
        self.configuration = configuration
        self.application = application

    def get_packages(self):
        return []

    def post_install(self):
        pass

    def setup_environment(self):
        pass


class FPM54(Interpretor):
    def __init__(self, configuration, application):
        super(FPM54, self).__init__(configuration, application)

        self.socket_address = None

    def configure(self, frontend):
        # If frontend supports unix sockets, use them by default
        self.socket_address = 'unix:/var/run/php5/fpm.sock'
        if not frontend.supports_unix_proxy():
            self.socket_address = '127.0.0.1:9000'

        # Clear pre-configured pools
        map(os.unlink, [os.path.join('/etc/php5/fpm/pool.d', f) for f in os.listdir('/etc/php5/fpm/pool.d')])
        templates_mapping = {
            'pool.conf': '/etc/php5/fpm/pool.d/tsuru.conf',
            'php-fpm.conf': '/etc/php5/fpm/php-fpm.conf'
        }

        for template, target in templates_mapping.iteritems():
            shutil.copyfile(
                os.path.join(self.application.get('source_directory'), 'php', 'interpretor', 'fpm54', template),
                target
            )

        # Replace pool listen address
        listen_address = self.socket_address
        if listen_address[0:5] == 'unix:':
            listen_address = listen_address[5:]

        replace(templates_mapping['pool.conf'], '_FPM_POOL_LISTEN_', listen_address)

        if 'ini_file' in self.configuration:
            shutil.copyfile(
                os.path.join(self.application.get('directory'), self.configuration.get('ini_file')),
                '/etc/php5/fpm/php.ini'
            )

        # Clean and touch some files
        for file_path in ['/var/log/php5-fpm.log', '/etc/php5/fpm/environment.conf']:
            open(file_path, 'a').close()
            os.system('chown %s %s' % (self.application.get('user'), file_path))

        # Clean run directory
        run_directory = '/var/run/php5'
        if not os.path.exists(run_directory):
            os.makedirs(run_directory)

        # Fix user rights
        os.system('chown -R %s /etc/php5/fpm /var/run/php5' % self.application.get('user'))

    def setup_environment(self):
        target = '/etc/php5/fpm/environment.conf'

        with open(target, 'w') as f:
            for (k, v) in self.application.get('env', {}).items():
                f.write('env[%s] = %s\n' % (k, v))

    def get_packages(self):
        return ['php5-fpm']

    def post_install(self):
        # Remove autostart
        os.system('service php5-fpm stop')

    def get_address(self):
        return self.socket_address

    def get_startup_cmd(self):
        return '/usr/sbin/php5-fpm --fpm-config /etc/php5/fpm/php-fpm.conf'


interpretors = {
    'fpm54': FPM54
}
