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
