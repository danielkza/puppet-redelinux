#!/usr/bin/env python2.7

import sys
import yaml
import json
import os.path
from subprocess import check_output
from copy import deepcopy

script_dir = os.path.dirname(os.path.realpath(__file__))

with open(os.path.join(script_dir, 'node_config.json')) as fp:
    node_configs = json.load(fp)

default_config = node_configs.pop('default', {
    'classes': {},
    'parameters': {}
})

def dict_merge(target, *args):
    # Merge multiple dicts
    if len(args) > 1:
        for obj in args:
            dict_merge(target, obj)
        return target

    # Recursively merge dicts and set non-dict values
    obj = args[0]
    if not isinstance(obj, dict):
        return obj
    for k, v in obj.iteritems():
        if k in target and isinstance(target[k], dict):
            dict_merge(target[k], v)
        else:
            target[k] = deepcopy(v)

    return target

def puppet_enc_classify(node_fqdn):
    try:
        node_name, node_domain = node_fqdn.split('.', 1)
    except ValueError:
        node_name = node_fqdn
        node_domain = None

    if not node_name or (node_domain and node_domain != 'linux.ime.usp.br'):
        return None

    node_groups_str = check_output([os.path.join(script_dir, 'megazord'),
                                    'machines', '--machine-groups', node_name])
    node_groups = set(node_groups_str.strip().split(','))
    
    # intersect node's groups with available config. groups
    node_groups.intersection_update(node_configs.keys())

    result = default_config
    for group in node_groups:
        dict_merge(result, node_configs[group])

    classes = result['classes']
    for k, v in classes.iteritems():
        if not k.startswith('::') and not k.startswith('redelinux::'):
            classes['redelinux::' + k] = v
            del classes[k]

    return yaml.safe_dump(result, explicit_start=True, default_flow_style=False)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(1)

    node_fqdn = sys.argv[1]
    result = puppet_enc_classify(node_fqdn)
    if result is not None:
        print result
    else:
        sys.exit(1)
