class redelinux::ldap
{
    Util::Cfg_file {
        source_prefix => "ldap"
    }

    # LDAP
    $ldap = ['libnss-ldapd', 'kstart']

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
    file { '/etc/ldap/ldap.conf':
        ensure  => absent,
        require => Package[$ldap],
    }
            
    util::cfg_file { '/etc/nslcd.conf':
        require => Package[$ldap],
        notify  => Service['nslcd'],
    }

    include redelinux::nsswitch

    anchor { 'redelinux::ldap::begin': }
    -> Class['redelinux::nsswitch']
    -> anchor { 'redelinux::ldap::end': }
}
