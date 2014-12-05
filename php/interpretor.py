# -*- coding: utf-8 -*-
import os
import shutil

class Interpretor(object):
    def __init__(self, configuration, application):
        self.configuration = configuration
        self.application = application

    def get_packages(self):
        return []

    def post_install(self):
        pass


class FPM54(Interpretor):
    def configure(self):
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

        # Clean log files
        for file_path in ['/var/log/php5-fpm.log']:
            open(file_path, 'a').close()
            os.system('chown %s %s' % (self.application.get('user'), file_path))

        # Clean run directory
        run_directory = '/var/run/php5'
        if not os.path.exists(run_directory):
            os.makedirs(run_directory)

        # Fix user rights
        os.system('chown -R %s /etc/php5/fpm /var/run/php5' % self.application.get('user'))

    def get_packages(self):
        return ['php5-fpm']

    def post_install(self):
        # Remove autostart
        os.system('update-rc.d php5-fpm disable')
        os.system('service php5-fpm stop')

    def get_address(self):
        return 'unix:/var/run/php5/fpm.sock'

    def get_startup_cmd(self):
        return '/usr/sbin/php5-fpm --fpm-config /etc/php5/fpm/php-fpm.conf'


interpretors = {
    'fpm54': FPM54
}
