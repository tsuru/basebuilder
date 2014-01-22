import os

import yaml


def load_commands(data):
    result = yaml.load(data)
    if result:
        hooks = result.get('hooks', {})
        if hooks:
            return hooks.get('build', [])
    return []


def execute_commands(commands):
    run = 0
    for command in commands:
        print "   Running hook: %s" % command
        os.system(command)
        run = run + 1

    if run > 0: 
       print "   Done executing hooks."
    else:
       print "   No hooks defined."


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
    print ""
    print ""
    print ""
    print "========================================"
    print " Parsing Hooks"
    print "========================================"
    print ""
    data = load_file()
    commands = load_commands(data)
    execute_commands(commands)


main()
