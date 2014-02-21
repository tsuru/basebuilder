import os
import yaml

def parse_env():
    for k, v in os.environ.items():       
        print("env[%s] = %r" % (k, v))

def parse_apprc():
    path = "/home/application/apprc"
    if os.path.exists(path):
        with open(path) as file:
            for line in file.readlines():
                if "export" in line:
                    line = line.replace("export ", "")
                    k, v = line.split("=")
                    v = v.replace("\n", "").replace('"', '')
                    print("env[%s] = %r" % (k, v))

def parse_envs_from_yml(data):
    result = yaml.load(data)
    if result:
        for dictionary in result.get('envs', {}):
            for k, v in dictionary.items():
                print("env[%s] = %r" % (k, v))

def load_and_parse_yml(working_dir="/home/application/current"):
    files_name = ["app.yaml", "app.yml"]
    for file_name in files_name:
        try:
            with open(os.path.join(working_dir, file_name)) as f:
                parse_envs_from_yml(f.read())
        except IOError:
            pass
    return ""


def main():
    parse_env()
    parse_apprc()
    load_and_parse_yml()

main()
