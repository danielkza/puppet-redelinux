define redelinux::util::cfg_concat(
    $path,
    $target       = $title,
    $source       = undef,
    $groups       = undef,
    $owner        = 'root',
    $group        = 'root',
    $mode         = '0644',
    $warn         = undef,
    $force        = undef,
    $backup       = undef,
    $order        = 'generic-first',
    $use_template = false,
) {
    case $order {
        'generic-first': {
            $order_def   = 10
            $order_group = 20
            $order_host  = 30
        }
        'generic-last': {
            $order_def   = 30
            $order_group = 20
            $order_host  = 10
        }
        default: {
            fail("invalid order `${order}`")
        }
    }

    $source_real = $source ? {
        undef => module_file_url($path),
        default => $source,
    } 

    concat { $target:
        path    => $path,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        warn    => $warn,
        force   => $force,
        backup  => $backup,
    }

    Redelinux::Util::Cfg_fragment {
        target       => $target,
        source       => $source_real,
        owner        => $owner,
        group        => $group,
        mode         => $mode,
        use_template => $use_template,
    }

    if !empty($host_groups) {
        each(sort($host_groups)) |$group| {
            util::cfg_fragment { "${target}_group_${group}":
                identifier => $group,
                selector   => 'group',
                order      => $order_group,
            }
        }
    }

    each([$::hostname, $::fqdn]) |$host| {
        util::cfg_fragment { "${target}_host_${host}":
            identifier => $host,
            selector   => 'host',
            order      => $order_host,
        }
    }

    util::cfg_fragment { "${target}_base":
        order      => $order,
    }
}