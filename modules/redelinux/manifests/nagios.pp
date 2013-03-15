class redelinux::nagios
{
    class server
    {
        $nagios_server = ['nagios3', 'nagios-plugins']
        package { $nagios_server:
            ensure => latest,
        }

        service { 'nagios3':
            ensure  => running,
            enable  => true,
            require => Package[$nagios_server],
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
