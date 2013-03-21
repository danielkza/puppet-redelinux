class redelinux::puppet_client
{
    include redelinux::params
    include redelinux::apt

    ::apt::source { 'puppetlabs':
        location          => 'http://apt.puppetlabs.com',
        repos             => 'main',
        include_src       => true,
        key               => '4BD6EC30',
        key_server        => 'subkeys.pgp.net',
    }
    
    # Puppet
    package { 'puppet':
        ensure  => present,
        require => Apt::Source['puppetlabs'],
    }

    service { 'puppet':
        enable  => false,
        require => Package['puppet'],
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
        require       => Package['puppet'],
    }
}
