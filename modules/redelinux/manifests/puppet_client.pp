class redelinux::puppet_client
{
    file { 'puppet.conf':
        ensure => file,
        path => '/etc/puppet/puppet.conf',
        source => 'puppet:///modules/redelinux/etc/puppet/puppet.conf',
    }
    
    file { 'puppet_default':
        ensure => file,
        path => '/etc/default/puppet',
        source => 'puppet:///modules/redelinux/etc/default/puppet',
    }
    
    service { 'puppet':
        ensure => running,
        subscribe => [
            File['puppet.conf'],
            File['puppet_default'],
        ],
    }
}
