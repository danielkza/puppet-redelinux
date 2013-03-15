class redelinux::nagios
{
    class server
    {
        package { ['nagios', 'nagios-plugins']:
            ensure => latest,
        }

        service { 'nagios':
            ensure  => running,
            enable  => true,
            require => Package['nagios'],
        }

        Nagios_host<<||>>
    }

    class host
    {
        @@nagios_host { $::hostname:
            ensure     => present,
            hostgroups => $redelinux::params::host_groups
        }
    }
}
