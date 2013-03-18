class redelinux::icinga
inherits redelinux::nagios::server
{
    class { 'redelinux::nagios':
        use_provider => 'icinga',
    }

    package { ['php5-pgsql', 'libbdb-pgsql']:
        ensure => installed,
        notify => Service['ido2db'],
    }

    service { 'ido2db':
        ensure  => running,
        enable  => true,
        require => Package['icinga'],
        before  => Service['icinga'],
    }

    util::config_file { 'ido2db.cfg':
        path   => "${conf_dir}/ido2db.cfg",
        mode   => '0600',
        notify => Service['ido2db', 'icinga'],
    }
}
