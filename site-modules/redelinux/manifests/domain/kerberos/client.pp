class redelinux::domain::kerberos::client
{
  Fileutil::Cfg_file {
    source_prefix => "kerberos"
  }

  package { ["krb5-user", "libpam-krb5"]:
    ensure => present
  }

  util::cfg_file { '/etc/krb5.conf':
    require => Package[$kerberos],
  }

  $principals = generate('/usr/bin/kadmin', '-k', '-q', 'listprincs */admin')

  if !empty($principals) {  
    k5login { 'root':
      ensure     => present,
      path       => '/root/.k5login',
      principals => $principals
    }
  }
}    
