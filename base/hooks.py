import os

import yaml


def load_commands(data):
    result = yaml.load(data)
    if result:
        return result.get('build', [])
    return []


def execute_commands(commands):
    for command in commands:
        os.system(command)


def load_file(working_dir="/home/application/current"):
    files_name = ["app.yaml", "app.yml"]
    for file_name in files_name:
        try:
            with open(os.path.join(working_dir, file_name)) as f:
                return f.read()
        except IOError:
            pass
    return ""
