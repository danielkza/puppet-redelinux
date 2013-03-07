class redelinux::puppet_client
{
    require redelinux::apt

    # Puppet
    package { 'puppet':
        ensure  => latest,
    }

    service { 'puppet':
        ensure  => running,
        enabled => true,
    }

    # Puppet's config files
    Util::Config_file {
        notify => Service['puppet'],
    }

    util::config_file { 'puppet.conf':
        path   => '/etc/puppet/puppet.conf',
    }
    
    util::config_file { 'puppet_default':
        path   => '/etc/default/puppet',
    }
    
    util::config_file { 'auth.conf':
        path   => '/etc/puppet/auth.conf',
    }

    util::config_file { 'namespaceauth.conf':
        path    => '/etc/puppet/namespaceauth.conf',
        content => '',
    }
}
