import os
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

def execute_links(app_dir, mountpoint, paths):
    for path in paths:
        path = os.path.normpath(path)

        if path[0] == '/':
            path = path.replace(path[:1], '')
        if path[:3] == '../':
            path = path.replace(path[:3], '')

        linkSource = os.path.join(mountpoint, path) # e.g: /mnt/sharedfs/wp-content
        linkDest = os.path.join(app_dir, path)      # e.g: /home/application/current/wp-content

        # Check existance of source directory in shared mount point
        if not os.path.exists(linkSource):
            os.makedirs(linkSource)

        # Remove old link, if exists or create the full dir path. 
        if os.path.exists(linkDest):
            # If it's a link, remove it (this should happens on a second push)
            if os.path.islink(linkDest):
                os.unlink(linkDest)   

            # Empty dir, remove it
            elif os.path.isdir(linkDest) and not os.listdir(linkDest):
                os.rmdir(linkDest)

           # Something strange here, dir not empty or not a link, skipping.
           else:
               print " %s already exists in repository and is not empty. Ignoring it." % path
               continue
        else:
           os.makedirs(linkDest)
           os.rmdir(linkDest)

        # Create symlink
        os.symlink(linkSource, linkDest)

        print " Sharing %s" % path

def main():
    print "Parsing directories to share..."

    app_dir = os.environ.get('TSURU_APP_DIR', '')
    mountpoint = os.environ.get('TSURU_SHAREDFS_MOUNTPOINT', '')

    if not mountpoint or not app_dir:
        return False

    data = load_file(app_dir)
    paths = load_paths(data)
    execute_links(app_dir, mountpoint, paths)

main()
