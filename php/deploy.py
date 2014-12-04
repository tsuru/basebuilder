import os
import yaml

from interpretor import interpretors
from frontend import frontends


class ConfigurationException(Exception):
    pass


class InstallationException(Exception):
    pass


class Manager(object):
    def __init__(self, configuration, application):
        self.configuration = configuration
        self.application = application

    def install(self):
        packages = self.frontend.get_packages()

        if self.interpretor is not None:
            packages += self.interpretor.get_packages()

        print('Installing system packages...')
        if os.system("apt-get install -y %s" % (' '.join(packages))) != 0:
            raise InstallationException('An error appeared while installing needed packages')

        # If there's no Procfile, create it
        Procfile_path = os.path.join(self.application.get('directory'), 'Procfile')
        if not os.path.isfile(Procfile_path):
            f = open(Procfile_path, 'w')
            f.write('frontend: %s\n' % self.frontend.get_startup_cmd())
            if self.interpretor is not None:
                f.write('interpretor: %s\n' % self.interpretor.get_startup_cmd())

            f.close()

    def configure(self):
        if self.interpretor is not None:
            print('Configuring interpretor...')
            self.interpretor.configure()

        print('Configuring frontend...')
        self.frontend.configure(self.interpretor)

    @property
    def frontend(self):
        frontend = self.configuration.get('frontend', {
            'name': 'apache-mod-php'
        })

        if 'name' not in frontend:
            raise ConfigurationException('Frontend name must be set')

        return self.get_frontend_by_name(frontend.get('name'))(frontend.get('options', {}), self.application)

    @property
    def interpretor(self):
        interpretor = self.configuration.get('interpretor', None)
        if interpretor is None:
            return None
        elif 'name' not in interpretor:
            raise ConfigurationException('Interpretor name must be set')

        return self.get_interpretor_by_name(interpretor.get('name'))(interpretor.get('options', {}), self.application)

    @staticmethod
    def get_interpretor_by_name(name):
        if name not in interpretors:
            raise ConfigurationException('Interpretor %s is unknown' % name)

        return interpretors.get(name)

    @staticmethod
    def get_frontend_by_name(name):
        if name not in frontends:
            raise ConfigurationException('Frontend %s is unknown' % name)

        return frontends.get(name)

def load_file(working_dir="/home/application/current"):
    files_name = ["app.yaml", "app.yml"]
    for file_name in files_name:
        try:
            with open(os.path.join(working_dir, file_name)) as f:
                return f.read()
        except IOError:
            pass

    return ""


def load_configuration():
    result = yaml.load(load_file())
    if result:
        return result.get('php', {})

    return {}


if __name__ == '__main__':
    # Load PHP configuration from `app.yml`
    config = load_configuration()

    # Create an application object from environ
    application = {
        'directory': '/home/application/current',
        'user': 'ubuntu',
        'source_directory': '/var/lib/tsuru'
    }

    # Run installation & configuration
    manager = Manager(config, application)
    manager.install()
    manager.configure()
