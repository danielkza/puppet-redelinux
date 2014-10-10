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
  util::cfg_file { 'sshd_config':
    path   => '/etc/ssh/sshd_config',
    notify => Service['ssh-server'],
  }*/
}
