class redelinux::nagios::server
inherits redelinux::nagios::params
{
    package { $package:
        ensure => latest,
        notify => Service[$service],
    }

    package { $plugins:
        ensure  => latest,
        require => Package[$package],
        notify  => Service[$service],
    }

    service { $service:
        ensure  => running,
        enable  => true,
    }   

    Util::Config_file {
        require => Package[$package, $plugins],
        notify =>> Service[$service],
    }

    util:config_file { 'nagios_object_dir':
        path    => "${conf_dir}/${object_subdir}/",
        ensure  => directory,
        recurse => remote,
    }

    util::config_file { 'nagios_default_groups':
        path    => "${conf_dir}/${object_subdir}/hostgroups_${default_cfg_suffix}.cfg",
        ensure  => absent,
    }

    Host_group<<||>>
    Host_entry<<||>>
}
