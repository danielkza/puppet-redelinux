class redelinux::puppet_client
{
    include redelinux::params
    include redelinux::apt

    # Puppet
    package { 'puppet':
        ensure => latest,
    }

    service { 'puppet':
        enable  => false,
        require => Package['puppet']
    }

    $puppet_cron_minute = rand_fqdn($redelinux::params::puppet_client_run_interval)

    cron { 'puppet-agent':
        ensure  => present,
        command => $redelinux::params::puppet_client_command
        user    => 'root',
        minute  => [$puppet_cron_minute, $puppet_cron_minute + 30],
        special => 'reboot',
        require => [Package['puppet'], Service['puppet']]
    }

    util::config_file { 'puppet.conf':
        path   => '/etc/puppet/puppet.conf',
        source => [
            'files:///modules/${module_name}/etc/puppet/puppet.conf',
            '/etc/puppet/puppet.conf',
        ]
    }
    
    #util::config_file { 'auth.conf':
    #    path => '/etc/puppet/auth.conf',
    #}
}
