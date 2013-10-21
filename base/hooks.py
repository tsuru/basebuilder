import yaml


def load_commands(data):
    result = yaml.load(data)
    if result:
        return result.get('build', [])
    return []
