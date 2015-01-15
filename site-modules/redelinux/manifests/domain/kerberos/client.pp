class redelinux::domain::kerberos::client
{
  File_util::Cfg {
    source_prefix => 'kerberos'
  }

  package { ['krb5-user', 'libpam-krb5']:
    ensure => installed
  }

  file_util::cfg { '/etc/krb5.conf':
    ensure  => present,
    require => Package['krb5-common']
  }

  $admin_princs = krb5_list_principals('*/admin')
  if !empty($admin_princs) {  
    k5login { 'root':
      ensure     => present,
      path       => '/root/.k5login',
      principals => $admin_princs
    }
  }
}    
