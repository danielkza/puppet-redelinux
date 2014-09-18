class nagios::icinga
inherits nagios::server
{
    class { 'nagios::nagios':
        use_provider => 'icinga',
    }

    package { ['php5-pgsql', 'libbdb-pgsql']:
        ensure => present,
        notify => Service['ido2db'],
    }

    service { 'ido2db':
        ensure  => running,
        enable  => true,
        require => Package['icinga'],
        before  => Service['icinga'],
    }

    util::cfg::file { 'ido2db.cfg':
        path   => "${conf_dir}/ido2db.cfg",
        mode   => '0600',
        notify => Service['ido2db', 'icinga'],
    }
}
