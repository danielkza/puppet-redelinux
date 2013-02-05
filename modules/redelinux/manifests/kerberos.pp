class redelinux::kerberos
{
	# Kerberos
	package { 'kerberos':
		name   => ["krb5-user", "libpam-krb5"],
		ensure => present
	}

	file { 'krb5.conf':
	    ensure  => file,
		path    => '/etc/krb5.conf',
		source  => 'puppet:///modules/redelinux/etc/krb5.conf',
		require => Package['kerberos']
	}
}	
