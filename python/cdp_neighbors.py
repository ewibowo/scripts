#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from __future__ import absolute_import, division, print_function


def get_config_cdp_neighbors(input_string):
    lines = input_string.splitlines()[5:]
    hostname = None
    config = []
    for line in lines:
        words = line.split()
        if hostname is None:
            hostname = words.pop(0).split('.')[0]
            if len(words) > 0:
                local = ''.join(words[0:2])
                remote = ''.join(words[-2:])
                description = '_'.join((hostname, remote))
                config.append('interface ' + local)
                config.append(' description ' + description)
                config.append('!')  # Added for looks only
                hostname = None
    return config
