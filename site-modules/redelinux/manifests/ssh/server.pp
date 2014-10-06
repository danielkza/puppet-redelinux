class redelinux::ssh::server
{
  package { 'ssh-server':
    ensure => installed,
    name   => 'openssh-server'
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
