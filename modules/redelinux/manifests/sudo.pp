class redelinux::sudo
{
    # Sudo
    package { 'sudo':
        ensure => present,
    }

    # Sudo's config files
    config_file { 'sudoers':
        path    => '/etc/sudoers',
        mode    => '0440',
        require => Package['sudo'],
    }
    
    file { 'sudoers.d':
        ensure  => directory,
        path    => '/etc/sudoers.d/',
        source  => 'puppet:///modules/redelinux/etc/sudoers.d/',
        owner   => root,
        group   => root,
        mode    => '0440',
        recurse => remote,
        require => Package['sudo'],
    }
}
