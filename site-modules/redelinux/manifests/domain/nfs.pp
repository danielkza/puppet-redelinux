class redelinux::domain::nfs
{
  Cfg_file {
    source_prefix => 'nfs'
  }

  # NFS
  package { 'nfs-common':
    ensure => installed,
    before => Service['nfs-common']
  }

  cfg_file { ['/etc/default/nfs-common', '/etc/idmapd.conf']:
    require => Package['nfs-common'],
    notify  => Service['nfs-common']
  }

  service { 'nfs-common':
    ensure  => running,
    enable  => true
  }

  # AutoFS
  package { 'autofs':
    ensure => installed,
    before => Service['autofs']
  }

  cfg_file {
    'autofs-default':
      path   => '/etc/default/autofs',
      notify => Service['autofs'];
    'autofs':
      path    => '/etc/autofs' 
      ensure  => directory,
      recurse => true,
      notify  => Service['autofs']
  }

  nsswitch::database { 'automount':
    services => 'files',
    require  => Package['autofs'],
    notify   => Service['autofs']
  }

  service { 'autofs':
    ensure => running,
    enable => true
  }

  # Customizations
  cfg_file { 'nfs-profile':
    path    => '/etc/profile.d/nfs_path.sh',
    mode    => '0655'
  }
}
