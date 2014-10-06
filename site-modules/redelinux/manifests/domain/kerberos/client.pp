class redelinux::domain::kerberos::client
{
  Fileutil::Cfg_file {
    source_prefix => 'kerberos'
  }

  package { ['krb5-user', 'libpam-krb5']:
    ensure => installed
  }

  util::cfg_file { '/etc/krb5.conf':
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
