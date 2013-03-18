define redelinux::config_concat(
    $path,
    $target  = $title,
    $owner   = 'root',
    $group   = 'root',
    $mode    = '0644',
    $warn    = undef,
    $force   = undef,
    $backup  = undef,
    $replace = undef,
) {
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

    concat::fragment { $target:
        target  => $target,
        content => template('redelinux/${target}.erb'),
        order   => 01,
    }

    Util::Config_fragment {
        target  => $target,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
    }

    if !empty($redelinux::host_groups) {
        util::config_fragment { $redelinux::params::host_groups:
            selector => 'group',
            order    => 02,
        }
    }

    util::config_fragment { [$::hostname, $::fqdn]:
        selector => 'host',
        order    => 03,
    }
}