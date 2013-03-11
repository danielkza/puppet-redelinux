class redelinux::ldap
{
    include redelinux::apt

    # LDAP
    $ldap = ['libnss-ldapd', 'libsasl2-modules-gssapi-mit', 'kstart']

    package { $ldap:
        ensure => present,
    }

    # We only want LDAP authentication, authorization is Kerberos' job
    package { 'libpam-ldapd':
        ensure  => absent,
        require => Package[$ldap],
    }

    service { 'nslcd':
        ensure  => running,
        enable  => true,
        require => Package[$ldap],
    }

    # LDAP config files
    file { 'ldap.conf':
        ensure  => absent,
        path    => '/etc/ldap/ldap.conf',
        require => Package[$ldap],
    }
            
    util::config_file { 'nslcd.conf':
        path    => '/etc/nslcd.conf',
        require => Package[$ldap],
        notify  => Service['nslcd'],
    }

    include redelinux::nsswitch
    Package[$ldap] -> Class['nsswitch']

    anchor { 'redelinux::ldap::begin': }
    -> Class['nsswitch']
    -> anchor { 'redelinux::ldap::end': }
}
