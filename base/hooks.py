import yaml


def load_commands(data):
    result = yaml.load(data)
    return result['build']
