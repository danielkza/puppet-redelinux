#!/usr/bin/env python2.7

import sys
import yaml
import subprocess

group_classes = {
    'servidores': [],
    'clientes':   ['desktop', 'programming']
}

def puppet_enc_classify(node_fqdn):
    # A client must match one of those classes. An empty class list means
    # no extra puppet-classes, while not being present will trigger an error

    # Common classes are defined in site.pp
    node_name, node_domain = node_fqdn.split('.', 1)

    if not node_name or (node_domain and node_domain != 'linux.ime.usp.br'):
        return None

    node_groups_str = subprocess.check_output('/megazord machines --machine-groups ' + none_name)
    node_groups = node_groups_str.split(',') or []

    node_groups.intersection_update(group_classes.keys())
    if not node_groups:
        return None

    node_classes = set()
    for group in node_groups:
        node_classes.update(group_classes[group])

    result = {
        'classes': ['redelinux::' + klass for klass in node_classes]
    }

    return yaml.dump(result, explicit_start=True, default_flow_style=False)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(1)

    node_fqdn = sys.argv[1]
    result = puppet_enc_classify(node_fqdn)
    if result is not None:
        print result
    else:
        sys.exit(1)

