class redelinux::ssh::client
{
  File_util::Cfg {
    source_prefix => 'ssh'
  }
  
  package { 'openssh-client':
    ensure => installed
  }

  /*
  file_util::cfg { 'ssh_config':
    path    => '/etc/ssh/ssh_config',
    require => Package['ssh-client'],
  }*/
}
