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

        util::config_file { 'nagios_redelinux-host':
            path    => '/etc/nagios3/conf.d/redelinux-host.cfg',
            before  => File['nagios_config_dir'],
        }

        file { 'nagios_default_groups':
            path    => '/etc/nagios/conf.d/hostgroups_nagios2.cfg',
            ensure  => absent,
            before  => File['nagios_config_dir'],
        }

        file { 'nagios_conf_dir':
            path    => $nagios_conf_dir,
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            recurse => true,
            require => Package[$nagios_package],
            notify  => Service[$nagios_service],
        }

        Redelinux::Nagios::Host::Host_group<<||>>
        -> Util::Config_file['nagios_redelinux-host']
        -> Redelinux::Nagios::Host::Host_entry<<||>> 
        -> File['nagios_conf_dir']
        ~> Service['nagios']
    }

    class host inherits redelinux::nagios
    {
        define host_group(
            $hostgroup_name    = $title,
            $ensure            = present,
            $alias             = $hostgroup_name,
            $hostgroup_members = undef,
        ) {
            util::config_file { "nagios_group_${hostgroup_name{}"
                ensure  => $ensure,
                path    => "${nagios_conf_dir}/group-${hostgroup_name}.cfg",
                content => template("redelinux/nagios_hostgroup.erb"),
            }
        }

        define host_entry(
            $host_name    = $title,
            $ensure       = present,
            $alias        = $title,
            $address      = $host_name,
            $parents      = undef,
            $hostgroups   = undef,
            $use          = undef,
            $check_period = undef,
        ) 
            util::config_file { "nagios_host_${host_name}":

                ensure  => $ensure,
                path    => "${nagios_conf_dir}/host-${host_name}.cfg":
                content => template("redelinux/nagios_host.erb"),
            }
        }

        @@host_entry { $::fqdn:
            ensure => present,
            alias  => $::hostname,
            use    => 'redelinux-host'
        }
        
        @@host_group { $redelinux::params::host_groups: }
}
