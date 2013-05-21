class nagios::host(
    $use         = 'generic-host',
    $host_groups = [],
)
{
    @@nagios::host_entry { $::fqdn:
        ensure      => present,
        host_alias  => $::hostname,
        use         => $use,
        hostgroups  => $host_groups,
    }

    # This is needed because we need to declare all the groups
    # with different titles so they don't collide latter on.
    # So what we do is create a wrapper that receives the group
    # name and creates the resource with a title derived from
    # the node's fqdn, but with the actual correct group name.

    define host_group_wrapper(
        $hostgroup_name  = $title,
        $ensure          = present,
        $hostgroup_alias = $hostgroup_name,
        $members         = undef,
    ) {
        @@nagios::host_group { "${::fqdn}-${hostgroup_name}":
            hostgroup_name    => $hostgroup_name,
            ensure            => $ensure,
            hostgroup_alias   => $hostgroup_alias,
            members           => $members,
        }
    }

    if !empty($host_groups) {
        host_group_wrapper { $host_groups: }
    }
}
