class redelinux::sudo
{
    include redelinux::apt
    
    # Sudo
    package { 'sudo':
        ensure => present,
    }

    # Sudo's config files
    util::config_file { 'sudoers':
        path    => '/etc/sudoers',
        mode    => '0440',
        require => Package['sudo'],
    }
    
    util::config_file { 'sudoers.d':
        ensure  => directory,
        path    => '/etc/sudoers.d/',
        mode    => '0440',
        require => Package['sudo'],
    }
}
