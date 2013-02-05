class redelinux::ldap
{
	include nsswitch
	
	Package['ldap'] -> Class['nsswitch']
		
	# LDAP
	package { 'ldap':
		name   => ['libnss-ldapd', 'libsasl2-modules-gssapi-mit', 'kstart'],
		ensure => present
	}
	
	package { 'libpam-ldapd':
		ensure  => absent,
		require => Package['ldap']
	}
	
	file { 'ldap.conf':
	    ensure  => absent,
		path    => '/etc/ldap/ldap.conf',
		require => Package['ldap']
	}
			
	file { 'nslcd.conf':
		ensure  => file,
		path    => '/etc/nslcd.conf',
		source  => 'puppet:///modules/redelinux/etc/nslcd.conf',
		require => Package['ldap']
	}

	service { 'nslcd':
		ensure    => running,
		enable    => true,
		require   => Package['ldap'],
		subscribe => File['nslcd.conf']
	}
}
