class redelinux::ssh
{
    include redelinux::apt

    class server
    {
        package { 'openssh-server':
            ensure => present,
        }
        
        service { 'ssh':
            ensure  => running,
            enable  => true,
        }

        util::config_file { 'ssh_server_config':
            path    => '/etc/ssh/sshd_config',
            require => Package['openssh-server'],
            notify  => Service['ssh'],
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
