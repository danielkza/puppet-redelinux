#!/usr/bin/env python

import sys
import os
import os.path
from copy import deepcopy

import json
import yaml
import pushy

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

def create_directory(path):
    try:
        os.makedirs(path)
    except OSError:
        if os.path.isdir(path):
            pass
        else:
            raise

# ============================================================================ #

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

def retrieve_node_config(path):
    try:
        with open(os.path.join(path)) as fp:
            return json.load(fp)
    except:
        sys.stderr.write("Failed to load node configuration!\n")

    return None

def retrieve_machine_info():
    cache_file = "/tmp/supermegazord/machines.json"

    machines = None
    group_aliases = None

    try:
        with pushy.connect("ssh:megazords", username="megazord") as conn:
            smz_machines = conn.modules.supermegazord.db.machines

            # Bring data locally so we can close the connection
            machines = {}
            for group, group_machines in smz_machines.machines.items():
                machines[group] = list(machine.hostname
                                       for machine in group_machines)

            group_aliases = {}
            for group, aliases in smz_machines.group_aliases().items():
                group_aliases[group] = list(aliases)
    except:
        sys.stderr.write("Failed to retrieve machine list from megazord, trying local cache...\n")
        
        try:
            with open(cache_file) as fp:
                data = json.load(fp)
            
            machines = data['machines'] # must exist
            group_aliases = data.get('group_aliases', None) # may exist
        except:
            sys.stderr.write("Cache load failed, cannot classify node!")
            return None, None
    else:
        create_directory(os.path.dirname(cache_file))

        try:
            with open(cache_file, 'w') as fp:
                json.dump({'machines': machines, 'group_aliases': group_aliases}, fp)
        except Exception as e:
            sys.stderr.write("Failed to update cache: " + str(e) + "n")
        else:
            sys.stderr.write("Updated machine cache.\n")

    return machines, group_aliases

def get_machine_groups(hostname, machines):
    return (group for group, group_machines in machines.iteritems()
            if hostname in group_machines)

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

    machines, group_aliases = retrieve_machine_info()
    
    if not machines:
        return None
    elif not group_aliases:
        group_aliases = machines.keys()

    node_groups = list(get_machine_groups(node_name, machines))

    result = {
        'classes': {},
        'parameters': {}
    }

    result = dict_merge(result, node_configs.get('default', {}))
    result = merge_config(result, node_configs.get('groups', None), node_groups)
    if node_config:
        result = dict_merge(result, node_config)

    result['classes'] = dict_merge(qualify_classes(result['classes']), {
        'redelinux::params': {
            'host_groups': node_groups
        }
    })

    return yaml.safe_dump(result, explicit_start=True, default_flow_style=False)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(1)

    node_fqdn = sys.argv[1]

    try:
        config_file = sys.argv[2]
    except IndexError:
        script_dir = os.path.dirname(os.path.realpath(__file__))
        config_file = os.path.join(script_dir, "node_config.json")

    node_configs = retrieve_node_config(config_file)
    if not node_configs:
        sys.exit(1)

    result = classify_node(node_fqdn, node_configs)
    if result:
        print result
    else:
        sys.exit(1)

