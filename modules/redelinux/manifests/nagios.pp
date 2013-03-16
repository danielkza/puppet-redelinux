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
        
        package { ['apache2', 'libapache2-mod-auth-kerb', 'libapache2-mod-authz-unixgroup']:
            ensure => latest,
        }

        service { 'nagios':
            name    => $nagios_service,
            ensure  => running,
            enable  => true,
            require => Package['nagios'],
        }

        util::config_file { 'nagios_conf_dir':
            path    => "${nagios_conf_dir}",
            ensure  => directory,
            recurse => remote,
            require => Package[$nagios_package],
            notify  => Service[$nagios_service],
        }

        util::config_file { 'nagios_redelinux-host':
            path    => "${nagios_conf_dir}/conf.d/redelinux-host.cfg",
        }

        file { 'hostgroups_nagios2.cfg':
            ensure  => absent,
            path    => "${nagios_conf_dir}/conf.d/hostgroups_nagios2.cfg",
        }

        file { 'services_nagios2.cfg':
            ensure  => absent,
            path    => "${nagios_conf_dir}/conf.d/services_nagios2.cfg",
        }

        file { 'extinfo_nagios2.cfg':
            ensure  => absent,
            path    => "${nagios_conf_dir}/conf.d/extinfo_nagios2.cfg",
        }
        Host_group<<||>>
        -> Host_entry<<||>>
        ~> Service['nagios']
    }

    define host_group(
        $hostgroup_name    = $title,
        $ensure            = present,
        $hostgroup_alias   = $hostgroup_name,
        $hostgroup_members = undef,
    ) {
        ensure_resource('redelinux::util::config_file', "nagios_group_${hostgroup_name}", {
            ensure  => $ensure,
            path    => "${nagios_conf_dir}/conf.d/group-${hostgroup_name}.cfg",
            content => template("redelinux/nagios_hostgroup.erb"),
            tag     => 'redelinux::nagios::host_group'
        })
    }

    define host_entry(
        $host_name    = $title,
        $ensure       = present,
        $host_alias   = $title,
        $address      = undef,
        $parents      = undef,
        $hostgroups   = undef,
        $use          = undef,
        $check_period = undef,
    ) {
        if $address == undef {
            $address_real = $host_name
        } else {
            $address_real = $address
        }

        ensure_resource('redelinux::util::config_file', "nagios_host_${host_name}", {
            ensure  => $ensure,
            path    => "${nagios_conf_dir}/conf.d/host-${host_name}.cfg",
            content => template("redelinux/nagios_host.erb"),
            tag     => 'redelinux::nagios::host',
        })
    }

    class host inherits redelinux::nagios
    {
        @@host_entry { $::fqdn:
            ensure      => present,
            host_alias  => $::hostname,
            use         => 'redelinux-host',
            hostgroups  => $redelinux::params::host_groups,
        }

        # This is needed because we need to declare all the groups
        # with different titles so they don't collide latter on
        define host_group_wrapper(
            $hostgroup_name    = undef,
            $ensure            = present,
            $hostgroup_alias             = $hostgroup_name,
            $hostgroup_members = undef,
        ) {
            if $hostgroup_name == undef {
                $hostgroup_name_real = $title
            } else {
                $hostgroup_name_real = $hostgroup_name
            }

            @@host_group { "${::fqdn}-${hostgroup_name_real}":
                hostgroup_name    => $hostgroup_name_real,
                ensure            => $ensure,
                hostgroup_alias   => $hostgroup_alias,
                hostgroup_members => $hostgroup_members,
            }
        }

        host_group_wrapper { $redelinux::params::host_groups: }
    }
}

