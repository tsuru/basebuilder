from unittest import TestCase
import os

from mock import patch

from hooks import load_commands, execute_commands, load_file, main


class LoadCmdsTest(TestCase):
    def test_load_commands(self):
        yaml = '''hooks:
  build:
    - python manage.py collectstatic
    - python manage.py migrate'''
        commands = load_commands(yaml)
        expected = [
            'python manage.py collectstatic',
            'python manage.py migrate',
        ]
        self.assertEqual(expected, commands)

    def test_load_commands_empty_data(self):
        commands = load_commands('')
        expected = []
        self.assertEqual(expected, commands)

    def test_load_commands_without_build(self):
        yaml = '''hooks:
other:
  - python manage.py collectstatic
  - python manage.py migrate'''
        commands = load_commands(yaml)
        expected = []
        self.assertEqual(expected, commands)


class ExecuteCommandsTest(TestCase):
    @patch("subprocess.call")
    def test_execute_commands(self, subprocess_call):
        execute_commands(["ble"])
        subprocess_call.assert_called_with("ble", shell=True,
                                           cwd="/home/application/current")

    @patch("subprocess.call")
    def test_execute_commands_specific_cwd(self, subprocess_call):
        execute_commands(["ble"], working_dir="/tmp")
        subprocess_call.assert_called_with("ble", shell=True,
                                           cwd="/tmp")


class LoadFileTest(TestCase):
    def setUp(self):
        self.working_dir = os.path.dirname(__file__)
        self.data = 'ble'

    def test_load_app_yaml(self):
        file = os.path.join(self.working_dir, "app.yaml")
        with open(file, "w") as f:
            f.write(self.data)
        data = load_file(self.working_dir)
        self.assertEqual(data, self.data)
        os.remove(file)

    def test_load_app_yml(self):
        file = os.path.join(self.working_dir, "app.yaml")
        with open(file, "w") as f:
            f.write(self.data)
        data = load_file(self.working_dir)
        self.assertEqual(data, self.data)
        os.remove(file)

    def test_load_without_app_files(self):
        data = load_file(self.working_dir)
        self.assertEqual(data, "")


class MainTest(TestCase):

    @patch("hooks.execute_commands")
    @patch("hooks.load_commands")
    @patch("hooks.load_file")
    def test_main(self, load_file, load_commands, execute_commands):
        load_file.return_value = ""
        load_commands.return_value = []
        main()
        load_file.assert_called_with()
        load_commands.assert_called_with("")
        execute_commands.assert_called_with([])
