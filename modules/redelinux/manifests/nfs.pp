class redelinux::nfs
{
    include redelinux::nsswitch
   
    $nfs = 'nfs-common'

    package { $nfs:
        ensure => present,
    }

    file { 'nfs-common_default':
        ensure  => file,
        path    => '/etc/default/nfs-common',
        source  => 'puppet:///modules/redelinux/etc/default/nfs-common',
        require => Package[$nfs],
	notify  => Service['nfs-common'],
    }
    
    file { 'idmapd.conf':
        ensure  => file,
        path    => '/etc/idmapd.conf',
        source  => 'puppet:///modules/redelinux/etc/idmapd.conf',
        require => Package[$nfs],
	notify  => Service['nfs-common'],
    }
    
    service { 'nfs-common':
        ensure    => running,
        enable    => true,
        require   => Package[$nfs],
    }
    
    # AutoFS
    package { 'autofs':
        ensure => present,
        require => Package[$nfs],
    }

    Package['autofs'] -> Class['nsswitch']
    
    file { 'autofs_default':
        ensure  => present,
        path    => '/etc/default/autofs',
        source  => 'puppet:///modules/redelinux/etc/default/autofs',
        require => Package['autofs'],
        notify  => Service['autofs']
    }
    
    file { 'autofs':
        ensure => directory,
        path   => '/etc/autofs/',
        source => 'puppet:///modules/redelinux/etc/autofs/',
        recurse => remote,
        require => Package['autofs'],
        notify  => Service['autofs']
    }

    $autofs_service_hasstatus = !$debian_pre_wheezy

    service { 'autofs':
        ensure    => running,
        enable    => true,
        hasstatus => $autofs_service_hasstatus,
        pattern   => 'automount',
        require   => Package['autofs'],
        subscribe => [
            Class['nsswitch'],
        ],
    }
    
    file { '/etc/profile.d/nfs_path.sh':
        ensure => file,
        source => 'puppet:///modules/redelinux/etc/profile.d/nfs_path.sh',
        require => Package['autofs'],
    }
}
