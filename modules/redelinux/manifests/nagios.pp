class redelinux::nagios(
    $nagios_package  = 'nagios3',
    $nagios_service  = 'nagios3',
    $nagios_conf_dir = '/etc/nagios3',
) {
    class server inherits redelinux::nagios
    {
        package { 'nagios':
            name   => $nagios_package,
            ensure => latest,
        }

        package { ['nagios-plugins', 'nagios-snmp-plugins', 'nagios-nrpe-plugin']:
            ensure => latest,
            notify => Service['nagios'],
        }

        service { 'nagios':
            name    => $nagios_service,
            ensure  => running,
            enable  => true,
            require => Package['nagios'],
        }

        file { 'nagios_conf_dir':
            path    => $nagios_conf_dir,
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            recurse => true,
            notify  => Service[$nagios_service],
        }

        Redelinux::Nagios::Host::Host_group<<||>>
        -> Nagios_host<<||>>
        -> File['nagios_conf_dir']
        ~> Service['nagios']
    }

    class host inherits redelinux::nagios
    {
        define host_group(
            $group_name = $title,
            $target     = undef
        ) {
            if $group_name != 'all' and !defined(Nagios_hostgroup[$group_name]) { 
                nagios_hostgroup { $group_name:
                    ensure         => present,
                    hostgroup_name => $group_name,
                    target         => $target,
                }
            }
        }

        @@host_group { $redelinux::params::host_groups: }

        @@nagios_host { $::fqdn:
            ensure     => present,
            use        => 'generic-host',
            alias      => $::hostname,
            hostgroups => join($redelinux::params::host_groups, ','),
            require    => Host_group[$redelinux::params::host_groups]
        }
    }
}
