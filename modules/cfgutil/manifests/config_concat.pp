define cfgutil::config_concat(
    $path,
    $host_groups = undef,
    $target      = $title,
    $owner       = 'root',
    $group       = 'root',
    $mode        = '0644',
    $warn        = undef,
    $force       = undef,
    $backup      = undef,
    $replace     = undef,
    $order       = 'generic-first',
) {
    $order ? {
        'generic-first': {
            $order_def   = 10
            $order_group = 20
            $order_host  = 30
        },
        'generic-last': {
            $order_def   = 30
            $order_group = 20
            $order_host  = 10
        },
        default: {
            fail("invalid order")
        }
    }

    concat { $target:
        path    => $path,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        warn    => $warn,
        force   => $force,
        backup  => $backup,
        replace => $replace,
    }

    Cfgutil::Config_fragment {
        target  => $target,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
    }

    $base_resource = ["${target}_base", ]
    $group_resources = zip(prefix($host_groups, "${target}_group_"), $host_groups)


    $host_names = [$::hostname, $::fqdn]
    $titles_to_host_names = hash(zip(prefix($host_names, "${target}_host_")))

    if !empty($host_groups) {
        Cfgutil::config_fragment { $host_groups:
            selector => 'group',
            order    => $order_group,
        }
    }

    Cfgutil::config_fragment { :
        selector => 'host',
        order    => $order_host,
    }
}