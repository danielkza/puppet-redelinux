node base
{
    #stage { ['pre-deploy', 'apt']: }
    #Stage['pre-deploy'] -> Stage['apt'] -> Stage['main']

    class { 'redelinux::network':
    #    stage => 'pre-deploy'
    }

    class { 'redelinux::apt':
    #    stage => 'apt'
    }

    include redelinux::ntp
    include redelinux::kerberos
    include redelinux::ldap
    include redelinux::nfs
    include redelinux::ssh
    #include redelinux::sudo
    
    include redelinux::desktop::apps
    include redelinux::desktop::mozilla 
    
    include redelinux::programming

}

node /^puppet/ inherits base
{
}

node default inherits base
{
    include redelinux::puppet_client
}
