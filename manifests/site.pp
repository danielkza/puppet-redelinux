node base
{
    stage { 'pre-deploy': } -> Stage['main']

    class { 'redelinux::network':
        stage => 'pre-deploy'
    }

    include redelinux::apt
    include redelinux::ntp
    include redelinux::kerberos
    include redelinux::ldap
    include redelinux::nfs
    include redelinux::ssh::server
    #include redelinux::sudo
    include redelinux::puppet_client
}

node default inherits base
{

}
