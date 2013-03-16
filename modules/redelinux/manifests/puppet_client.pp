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

    $minutes = interval($redelinux::params::puppet_client_hourly_runs, 60)

    cron { 'puppet-agent':
        ensure  => present,
        command => $redelinux::params::puppet_client_command,
        user    => 'root',
        minute  => $minutes,
        require => [Package['puppet'], Service['puppet']]
    }

    util::config_file { 'puppet.conf':
        path          => '/etc/puppet/puppet.conf',
        extra_sources => ['/etc/puppet/puppet.conf'],
    }
    
    #util::config_file { 'auth.conf':
    #    path => '/etc/puppet/auth.conf',
    #}
}
