class redelinux::domain::kerberos(
  $extra_principals = []
) {
  File_util::Cfg {
    source_prefix => 'kerberos'
  }

  package { ['krb5-user', 'libpam-krb5', 'kstart']:
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

  $trusted_host_name = $trusted[certname]
  if ! empty($trusted_host_name) {
	  $principals = ["host/$trusted_host_name"] + $extra_principals
	
	  redelinux::keytab { '/etc/krb5.keytab':
	    principals        => $principals,
	    create_principals => false,
	    owner             => 'root',
	    group             => 'root'
	  }
	} else {
	  warning("Trusted hostname not available, skipping keytab")
	}
}
