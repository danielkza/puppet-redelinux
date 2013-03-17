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
            path    => "${nagios_conf_dir}/conf.d",
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            require => Package[$nagios_package],
            notify  => Service[$nagios_service],
        }

        util::config_file { 'nagios_redelinux-host':
            path    => '/etc/nagios3/conf.d/redelinux-host.cfg',
            require => File['nagios_conf_dir'],
        }

        file { 'nagios_default_groups':
            ensure  => absent,
            path    => '/etc/nagios/conf.d/hostgroups_nagios2.cfg',
            require => File['nagios_conf_dir'],
        }

        Host_group<<||>>
        -> Host_entry<<||>>
        ~> Service['nagios']
    }

    define host_group(
        $hostgroup_name    = $title,
        $ensure            = present,
        $alias             = $hostgroup_name,
        $hostgroup_members = undef,
    ) {
        notify { "host_group_name: ${hostgroup_name}": }
        ensure_resource('redelinux::util::config_file', "nagios_group_${hostgroup_name}", {
            ensure  => $ensure,
            path    => "${nagios_conf_dir}/group-${hostgroup_name}.cfg",
            content => template("redelinux/nagios_hostgroup.erb"),
            tag     => 'redelinux::nagios::host_group'
        })
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
    ) {
        ensure_resource('redelinux::util::config_file', "nagios_host_${host_name}", {
            ensure  => $ensure,
            path    => "${nagios_conf_dir}/host-${host_name}.cfg",
            content => template("redelinux/nagios_host.erb"),
            tag     => 'redelinux::nagios::host',
        })
    }

    class host inherits redelinux::nagios
    {

        @@host_entry { $::fqdn:
            ensure => present,
            alias  => $::hostname,
            use    => 'redelinux-host',
        }

        # This is needed because we need to declare all the groups
        # with different titles so they don't collide latter on
        define host_group_wrapper(
            $hostgroup_name    = $title,
            $ensure            = present,
            $alias             = $hostgroup_name,
            $hostgroup_members = undef,
        ) {
            @@host_group { "${::fqdn}-${hostgroup_name}":
                hostgroup_name    => $hostgroup_name,
                ensure            => $ensure,
                alias             => $alias,
                hostgroup_members => $hostgroup_members,
            }
        }

        if !empty($redelinux::params::host_groups) {
            host_group_wrapper { $redelinux::params::host_groups: }
        }
    }
}

