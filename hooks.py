import os
import subprocess
import sys

import yaml


def load_commands(data):
    result = yaml.load(data)
    if result:
        hooks = result.get('hooks', {})
        if hooks:
            return hooks.get('build', [])
    return []


def execute_commands(commands, working_dir="/home/application/current"):
    for command in commands:
        status = subprocess.call(command, shell=True, cwd=working_dir)
        if status != 0:
            sys.exit(status)


def load_file(working_dir="/home/application/current"):
    files_name = ["app.yaml", "app.yml"]
    for file_name in files_name:
        try:
            with open(os.path.join(working_dir, file_name)) as f:
                return f.read()
        except IOError:
            pass
    return ""


def main():
    if os.environ.get('TSURU_DEPLOY_NO_ENVS'):
        # No environment variables sent to deploy script we'll assume hooks
        # are being handled by tsuru-unit-agent.
        return
    data = load_file()
    commands = load_commands(data)
    execute_commands(commands)


main()
