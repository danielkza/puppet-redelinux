class redelinux::ssh
{
    require redelinux::apt
    
    anchor { 'redelinux::ssh::begin',
             'redelinux::ssh::end': }

    Anchor['redelinux::ssh::begin']
    -> Class['server', 'client']
    -> Anchor['redelinux::ssh::end']

    class server
    {
        package { 'openssh-server':
            ensure => present,
        }

        util::config_file { 'ssh_server_config':
            path    => '/etc/ssh/sshd_config',
            require => Package['openssh-server']
        }
    }

    class client
    {
        package { 'openssh-client':
            ensure => present,
        }

        util::config_file { 'ssh_client_config':
            path    => '/etc/ssh/ssh_config',
            require => Package['openssh-client']
        }
    }
}
