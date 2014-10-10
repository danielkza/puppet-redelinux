class redelinux::domain::kerberos::client
{
  Cfg_file {
    source_prefix => 'kerberos'
  }

  package { ['krb5-user', 'libpam-krb5']:
    ensure => installed
  }

  cfg_file { '/etc/krb5.conf':
    ensure  => present,
    require => Package[$kerberos]
  }

  $admin_princs = krb5_list_principals('*/admin')
  if !empty($admin_princs) {  
    k5login { 'root':
      ensure     => present,
      path       => '/root/.k5login',
      principals => $principals
    }
  }
}    
