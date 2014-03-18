import os
import sys
import yaml

def load_file(app_dir):
    files_name = ["app.yaml", "app.yml"]
    for file_name in files_name:
        try:
            with open(os.path.join(app_dir, file_name)) as f:
                return f.read()
        except IOError:
            pass
    return ""

def load_paths(data):
    result = yaml.load(data)
    if result:
        return result.get('sharedfs', [])
    return []

def execute_links(paths):
    app_dir = os.environ.get('TSURU_APP_DIR', '')
    mountpoint = os.environ.get('TSURU_SHAREDFS_MOUNTPOINT', '')

    run = 0
    for path in paths:
        run = run + 1

        path = os.path.normpath(path)

        if path[0] == '/':
            path = path.replace(path[:1], '')
        if path[:3] == '../':
            path = path.replace(path[:3], '')

        linkdest = os.path.join(mountpoint, path)
        linksource = os.path.join(app_dir, path)

        # Check existance of directory in shared mount point
        if not os.path.exists(linkdest):
            os.makedirs(linkdest)

        # Remove old link, if exists or create the full dir path
        if os.path.exists(linksource):
           os.unlink(linksource)
        else:
           os.makedirs(linksource)
           os.rmdir(linksource)

        # Create symlink if not exist
        if not os.path.exists(linkdest):
            os.symlink(linkdest,linksource)

        print " Sharing %s" % (path)

def main():
    print "Parsing directories to share..."

    app_dir = os.environ.get('TSURU_APP_DIR', '')
    mountpoint = os.environ.get('TSURU_SHAREDFS_MOUNTPOINT', '')

    print " APP_DIR: %s - MOUNTPOINT: %s" % (app_dir, mountpoint)

    if not mountpoint or not app_dir:
        print " Skipping shared fs, missing environments."
        return False

    data = load_file(app_dir)
    paths = load_paths(data)
    execute_links(paths)

main()
