class redelinux::puppet_client
{
    include redelinux::util

    # Puppet
    package { 'puppet':
        ensure  => latest,
    }

    service { 'puppet':
        ensure  => running,
        enabled => true,
    }

    # Puppet's config files
    Config_file {
        notify => Service['puppet'],
    }

    config_file { 'puppet.conf':
        path   => '/etc/puppet/puppet.conf',
    }
    
    config_file { 'puppet_default':
        path   => '/etc/default/puppet',
    }
    
    config_file { 'auth.conf':
        path   => '/etc/puppet/auth.conf',
    }

    config_file { 'namespaceauth.conf':
        path    => '/etc/puppet/namespaceauth.conf',
        content => '',
    }
}
