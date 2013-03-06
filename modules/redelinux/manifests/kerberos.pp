class redelinux::kerberos
{
    include redelinux::util

    # Kerberos
    $kerberos = ["krb5-user", "libpam-krb5"]

    package { $kerberos:
        ensure => present,
    }

    config_file { 'krb5.conf':
        path    => '/etc/krb5.conf',
        require => Package[$kerberos],
    }
}    
