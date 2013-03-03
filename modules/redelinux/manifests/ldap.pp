class redelinux::ldap
{
    include redelinux::nsswitch
            
    # LDAP
    $ldap = ['libnss-ldapd', 'libsasl2-modules-gssapi-mit', 'kstart']

    package { $ldap:
        ensure  => present,
    }
    
    Package[$ldap] -> Class['nsswitch'] 
    
    package { 'libpam-ldapd':
        ensure  => absent,
        require => Package[$ldap],
    }
    
    file { 'ldap.conf':
        ensure  => absent,
        path    => '/etc/ldap/ldap.conf',
        require => Package[$ldap],
    }
            
    file { 'nslcd.conf':
        ensure  => file,
        path    => '/etc/nslcd.conf',
        source  => 'puppet:///modules/redelinux/etc/nslcd.conf',
        require => Package[$ldap],
	notify  => Service['nslcd'],
    }

    service { 'nslcd':
        ensure    => running,
        enable    => true,
        require   => Package[$ldap],
    }
}
