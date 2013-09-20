define redelinux::util::cfg::concat(
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

    Util::Cfg::Fragment {
        target  => $target,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
    }

    each($host_groups) |$group| {
        util::cfg::fragment { "${target}_group_${group}":
            name     => $group,
            selector => 'group',
            order    => $order_group,
        }
    }

    each([$::hostname, $::fqdn]) |$host| {
        util::cfg::fragment { "${target}_host_${host}":
            name     => $group,
            selector => 'host',
            order    => $order_host,
        }
    }

    util::cfg::fragment { "${target}_base":
        name     => $base,
        order    => $order,
    }
}