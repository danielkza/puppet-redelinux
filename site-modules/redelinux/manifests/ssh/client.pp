class redelinux::ssh::client
{
  Cfg_file {
    source_prefix => 'ssh'
  }
  
  package { 'openssh-client':
    ensure => installed
  }

  /*
  util::cfg_file { 'ssh_config':
    path    => '/etc/ssh/ssh_config',
    require => Package['ssh-client'],
  }*/
}
