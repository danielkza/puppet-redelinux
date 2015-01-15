class redelinux::ssh::server
{
  package { 'openssh-server':
    ensure => installed
  }

  service { 'ssh':
    ensure  => running,
    enable  => true,
    require => Package['openssh-server']
  }

  /*
  file_util::cfg { 'sshd_config':
    path   => '/etc/ssh/sshd_config',
    notify => Service['ssh-server'],
  }*/
}
