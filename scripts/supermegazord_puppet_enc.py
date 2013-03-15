#!/usr/bin/env python2.7

import sys
import yaml
import json
import os.path
from subprocess import check_output
from copy import deepcopy

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

def parse_fqdn(node_fqdn, node_configs):
    try:
        node_name, node_domain = node_fqdn.split('.', 1)
    except ValueError:
        node_name = node_fqdn
        node_domain = None

    if not node_name or (node_domain and node_domain != 'linux.ime.usp.br'):
        return None, None

    try:
        node_name = node_configs['aliases'][node_name]
    except KeyError:
        pass
    
    return node_name, node_domain

def merge_config(config, config_dict, keys):
    if config_dict is None:
        return config

    if not isinstance(keys, str):
        keys = set(keys)
        keys.intersection_update(config_dict.iterkeys())

        for key in keys:
            config = merge_config(config, config_dict, key)

        return config

    return dict_merge(config, config_dict[key])

def qualify_classes(classes):
    qual_classes = {}
    for k, v in classes.iteritems():
        if k.startswith('::'):
            k = k[2:]
        elif not k.startswith('redelinux::'):
            k = 'redelinux::' + k

        qual_classes[k] = v

    return qual_classes

def classify_node(node_fqdn, node_configs):
    node_name, node_domain = parse_fqdn(node_fqdn, node_configs)
    if node_name is None:
        return None

    try:
        node_config = node_configs['hosts'][node_name]
    except KeyError:
        node_config = None
    
    node_groups_str = check_output([os.path.join(script_dir, 'megazord'),
                                    'machines', '--machine-groups', node_name])
    node_groups = set(node_groups_str.strip().split(','))

    result = {
        'classes': {},
        'parameters': {}
    }

    result = dict_merge(result, node_configs.get('default', {}))
    result = merge_config(result, node_configs.get('groups', None), node_groups)
    if node_config:
        result = dict_merge(result, node_config)

    result['classes'] = qualify_classes(result['classes'])
    result['parameters'].update({
        'redelinux_host_groups': list(node_groups)
    })

    return yaml.safe_dump(result, explicit_start=True, default_flow_style=False)

##

script_dir = os.path.dirname(os.path.realpath(__file__))

with open(os.path.join(script_dir, 'node_config.json')) as fp:
    node_configs = json.load(fp)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(1)

    node_fqdn = sys.argv[1]
    result = classify_node(node_fqdn, node_configs)
    if result is not None:
        print result
    else:
        sys.exit(1)

