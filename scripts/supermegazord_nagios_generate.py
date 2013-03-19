#!/usr/bin/env python2.7

import pushy

def group_format(group, members):
    template = """
define hostgroup {{
    hostgroup_name {name}
    alias          {alias}
    members        {members}
}}
"""
    return template.format(name=group, alias=group,
                           members=','.join(machine.hostname
                                            for machine in members))

def host_format(name):
    template = """
define host {{
    host_name    {name}
    alias        {alias}
    address      {address}
    use          redelinux-host
}}
"""
    fqdn = name + ".linux.ime.usp.br"
    return template.format(name=name, alias=name, address=fqdn)

with pushy.connect("ssh:megazord", username="megazord") as conn:
    machines = conn.modules.supermegazord.db.machines

    groups = machines.group_aliases().keys()

    groups_content = ''
    hosts_content = ''
    
    for group in groups:
        group_machines = machines.list(group)

        groups_content += group_format(group, group_machines)
        hosts_content += ''.join(host_format(machine.hostname)
                                 for machine in group_machines) + "\n"

    print groups_content
    print hosts_content
