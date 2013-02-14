class redelinux::sudo
{
    package { 'sudo':
        ensure => present,
    }

    file { 'sudoers':
        ensure  => file,
        path    => '/etc/sudoers',
        owner   => root,
        group   => root,
        mode    => 440,
        source  => 'puppet:///modules/redelinux/etc/sudoers',
        require => Package['sudo'],
    }
    
    file { 'sudoers.d':
        ensure  => directory,
        path    => '/etc/sudoers.d',
        owner   => root,
        group   => root,
        mode    => 440,
        source  => 'puppet:///modules/redelinux/etc/sudoers.d/',
        recurse => remote,
        require => Package['sudo'],
    }
}
