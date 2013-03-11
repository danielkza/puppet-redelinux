class redelinux::kerberos
{
    include redelinux::apt
    
    # Kerberos
    $kerberos = ["krb5-user", "libpam-krb5"]

    package { $kerberos:
        ensure => present,
    }

    util::config_file { 'krb5.conf':
        path    => '/etc/krb5.conf',
        require => Package[$kerberos],
    }
    
    $group = $redelinux::params::kerberos_admin_group
    $realm = $redelinux::params::kerberos_realm
    
    $users_line = generate('getent', 'group', $group)
    $users_list = regsubst($users_line, '^.+:', '')
    $principals = split(regsubst(',', "/admin@${realm}",'), ',')
    notice("principals: ${principals}")
    
    #k5login { 'redelinux':
    #    ensure     => present,
    #    path       => '/root/.k5login',
    #    principals => $principals
    #}    
}    
