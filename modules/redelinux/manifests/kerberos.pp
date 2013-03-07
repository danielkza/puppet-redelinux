class redelinux::kerberos
{
    require redelinux::apt
    
    # Kerberos
    $kerberos = ["krb5-user", "libpam-krb5"]

    package { $kerberos:
        ensure => present,
    }

    util::config_file { 'krb5.conf':
        path    => '/etc/krb5.conf',
        require => Package[$kerberos],
    }
}    
