class redelinux::ssh::client
{
  Fileutil::Cfg_file {
    source_prefix => 'ssh'
  }
  
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
