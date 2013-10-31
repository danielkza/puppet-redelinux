class redelinux::sudo
{    
    # Sudo
    package { 'sudo':
        ensure => present,
    }

    # Sudo's config files
    util::cfg_file { 'sudoers':
        path    => '/etc/sudoers',
        mode    => '0440',
        require => Package['sudo'],
    }
    
    util::cfg_file { 'sudoers.d':
        ensure  => directory,
        path    => '/etc/sudoers.d/',
        mode    => '0440',
        require => Package['sudo'],
    }
}
