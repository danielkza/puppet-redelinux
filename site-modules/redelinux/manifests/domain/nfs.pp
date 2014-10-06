class redelinux::nfs
{
  Redelinux::Util::Cfg_file {
    source_prefix => "nfs"
  }

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
  util::cfg_file { '/etc/default/nfs-common':
    require => Package[$nfs],
    notify  => Service['nfs-common'],
  }

  util::cfg_file { '/etc/idmapd.conf':
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
  util::cfg_file { '/etc/default/autofs':
    require => Package['autofs'],
    notify  => Service['autofs']
  }

  util::cfg_file { '/etc/autofs':
    ensure  => directory,
    recurse => true,
    require => Package['autofs'],
    notify  => Service['autofs'],
  }

  util::cfg_file { 'nfs_profile':
    path    => '/etc/profile.d/nfs_path.sh',
    mode    => '0655',
    require => Package['autofs'],
  }

  nsswitch::database { 'automount':
    services => 'files'
  }
}
