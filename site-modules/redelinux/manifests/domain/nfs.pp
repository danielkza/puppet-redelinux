class redelinux::domain::nfs
{
  File_util::Cfg {
    source_prefix => 'nfs'
  }

  # NFS
  package { 'nfs-common':
    ensure => installed,
    before => Service['nfs-common']
  }

  file_util::cfg { ['/etc/default/nfs-common', '/etc/idmapd.conf']:
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

  file_util::cfg {
    'autofs-default':
      path   => '/etc/default/autofs',
      notify => Service['autofs'];
    'autofs':
      path    => '/etc/autofs',
      ensure  => directory,
      recurse => true,
      notify  => Service['autofs']
  }
  
  include nsswitch

  Class['Nsswitch'] {
    automount => ['files']
  }
    
  Package['autofs'] -> Class['Nsswitch'] ~> Service['autofs']

  service { 'autofs':
    ensure => running,
    enable => true
  }

  # Customizations
  file_util::cfg { '/etc/profile.d/nfs_path.sh':
    mode => '0655'
  }
}
