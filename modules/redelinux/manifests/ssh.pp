class redelinux::ssh
{
    class redelinux::ssh::server
    {
        package { 'openssh-server':
            ensure => present,
        }

        file { 'sshd_config':
            ensure => file,
            path   => '/etc/ssh/sshd_config',
            source => 'puppet:///modules/redelinux/etc/ssh/sshd_config'
        }
    }

    class redelinux::ssh::client
    {
        package { 'openssh-client':
            ensure => present,
        }

        file { 'sshd_config':
            ensure => file,
            path   => '/etc/ssh/ssh_config',
            source => 'puppet:///modules/redelinux/etc/ssh/ssh_config'
        }
    }
}
