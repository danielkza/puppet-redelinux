class redelinux::kerberos
{
    # Kerberos
    $kerberos = ["krb5-user", "libpam-krb5"]

    package { $kerberos:
        ensure => present,
    }

    file { 'krb5.conf':
        ensure  => file,
        path    => '/etc/krb5.conf',
        source  => 'puppet:///modules/redelinux/etc/krb5.conf',
        require => Package[$kerberos],
    }
}    
