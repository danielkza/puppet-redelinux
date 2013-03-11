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
    
    include redelinux::desktop::apps
    include redelinux::desktop::mozilla
    include redelinux::desktop::xfce
    
    include redelinux::programming
}

node /^puppet/ inherits base
{
}

node default inherits base
{
    include redelinux::puppet_client
}
