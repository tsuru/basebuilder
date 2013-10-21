from unittest import TestCase

from mock import patch

from hooks import load_commands, execute_commands


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
    @patch("os.system")
    def test_execute_commands(self, system):
        execute_commands(["ble"])
        system.assert_called_with("ble")
