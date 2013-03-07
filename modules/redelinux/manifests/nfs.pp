class redelinux::nfs
{   
    $nfs = 'nfs-common'

    # NFS
    package { $nfs:
        ensure => present,
    }

    service { 'nfs-common':
        ensure    => running,
        enable    => true,
        require   => Package[$nfs],
    }

    # NFS config files
    util::config_file { 'nfs-common_default':
        path    => '/etc/default/nfs-common',
        require => Package[$nfs],
        notify  => Service['nfs-common'],
    }
    
    util::config_file { 'idmapd.conf':
        path    => '/etc/idmapd.conf',
        require => Package[$nfs],
        notify  => Service['nfs-common'],
    }
    
    # AutoFS
    package { 'autofs':
        ensure => present,
        require => Package[$nfs],
    }

    $autofs_service_hasstatus = !$debian_pre_wheezy
    service { 'autofs':
        ensure    => running,
        enable    => true,
        hasstatus => $autofs_service_hasstatus,
        pattern   => 'automount',
        require   => Package['autofs'],
    }
    
    # AutoFS config files
    util::config_file { 'autofs_default':
        path    => '/etc/default/autofs',
        require => Package['autofs'],
        notify  => Service['autofs']
    }
    
    file { 'autofs':
        ensure => directory,
        path   => '/etc/autofs/',
        source => 'puppet:///modules/redelinux/etc/autofs/',
        owner   => 'root',
        group   => 'root',
        mode    => 'a=r,u+w',
        recurse => remote,
        require => Package['autofs'],
        notify  => Service['autofs']
    }


    util::config_file { 'nfs_profile':
        path       => '/etc/profile.d/nfs_path.sh',
        mode       => 'a=rx,u+w',
        require    => Package['autofs'],
    }

    include redelinux::nsswitch

    # Apply nsswitch after installing autofs, and make changes to nsswitch
    # notify the autofs service.
    Package['autofs'] -> Class['nsswitch'] ~> Service['autofs']
}
