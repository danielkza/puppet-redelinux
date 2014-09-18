class redelinux::ssh
{
    Fileutil::Cfg_file {
        source_prefix => 'ssh'
    }

    class server
    {
        package { 'ssh-server':
            name   => 'openssh-server',
            ensure => present,
        }
        
        service { 'ssh-server':
            name    => 'ssh',
            ensure  => running,
            enable  => true,
            require => Package['ssh-server'],
        }

        /*
        util::cfg_file { 'sshd_config':
            path   => '/etc/ssh/sshd_config',
            notify => Service['ssh-server'],
        }*/
    }

    class client
    {
        package { 'ssh-client':
            name   => 'openssh-client',
            ensure => present,
        }

        /*
        util::cfg_file { 'ssh_config':
            path    => '/etc/ssh/ssh_config',
            require => Package['ssh-client'],
        }*/
    }
}