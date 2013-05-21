class redelinux::nfs
{
    include redelinux::params

    $nfs = 'nfs-common'

    # NFS
    package { $nfs:
        ensure => present,
    }

    service { 'nfs-common':
        ensure  => running,
        enable  => true,
        require => Package[$nfs],
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
        ensure  => present,
        require => Package[$nfs],
    }

    $autofs_service_hasstatus = !$redelinux::params::debian_pre_wheezy
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
    
    util::config_file { 'autofs':
        ensure  => directory,
        path    => '/etc/autofs/',
        recurse => true,
        require => Package['autofs'],
        notify  => Service['autofs'],
    }

    util::config_file { 'nfs_profile':
        path    => '/etc/profile.d/nfs_path.sh',
        mode    => '0655',
        require => Package['autofs'],
    }

    include redelinux::nsswitch
    Class['redelinux::nsswitch'] ~> Service['autofs']

    # Stupid anchor
    anchor { 'redelinux::nfs::begin': }
    -> Class['redelinux::nsswitch']
    -> anchor { 'redelinux::nfs::end': }
}
