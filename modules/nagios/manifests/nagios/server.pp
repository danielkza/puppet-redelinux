class nagios::server
inherits nagios::params
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

    Util::cfg::file {
        require => Package[$package, $plugins],
        notify  => Service[$service],
    }
    
    util::cfg::file { 'nagios_default':
        path    => "/etc/default/${service}",
        ensure  => file,
    }

    util::cfg::file { 'nagios_conf_dir':
        path    => "${conf_dir}",
        ensure  => directory,
        recurse => true,
    }

    util::cfg::file { 'nagios_default_groups':
        path    => "${object_dir}/hostgroups_${default_cfg_suffix}.cfg",
        ensure  => absent,
    }

    util::cfg::file { 'nagios_default_services':
        path    => "${object_dir}/services_${default_cfg_suffix}.cfg",
        ensure  => absent,
    }
    
    util::cfg::file { 'nagios_default_extinfo':
        path    => "${object_dir}/extinfo_${default_cfg_suffix}.cfg",
        ensure  => absent,
    }

    Nagios::Host_group<<||>> ~> Service[$service]
    Nagios::Host_entry<<||>> ~> Service[$service]
}
