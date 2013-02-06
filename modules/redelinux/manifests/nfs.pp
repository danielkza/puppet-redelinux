class redelinux::nfs
{
	include nsswitch

	Package['nfs'] -> Package['autofs'] -> Class['nsswitch']
	
	# NFS
	package { 'nfs':
		name   => 'nfs-common',
		ensure => present
	}

	file { 'nfs-common_default':
		ensure  => file,
		path    => '/etc/default/nfs-common',
		source  => 'puppet:///modules/redelinux/etc/default/nfs-common',
		require => Package['nfs']
	}
	
	file { 'idmapd.conf':
		ensure  => file,
		path    => '/etc/idmapd.conf',
		source  => 'puppet:///modules/redelinux/etc/idmapd.conf',
		require => Package['nfs'],
	}
	
	service { 'nfs-common':
		ensure    => running,
		enable    => true,
		require   => Package['nfs'],
		subscribe => [
			File['idmapd.conf'],
			File['nfs-common_default']
		],
	}
	
	# AutoFS
	package { 'autofs':
		ensure => present
	}
	
	file { 'autofs_default':
		ensure => present,
		path   => '/etc/default/autofs',
		source => 'puppet:///modules/redelinux/etc/default/autofs',
		require => Package['autofs'],
	}
	
	file { 'autofs':
		ensure => directory,
		path   => '/etc/autofs/',
		source => 'puppet:///modules/redelinux/etc/autofs/',
		recurse => remote,
		require => Package['autofs'],
	}
	
	service { 'autofs':
		ensure    => running,
		enable    => true,
		hasstatus => false,
		pattern   => 'automount',
		require  => Package['autofs'],
		subscribe => [
			File['autofs_default'],
			File['autofs'],
			Class['nsswitch']
		],
	}
	
	# Misc. files
	file { '/etc/profile.d/nfs_path.sh':
		ensure => file,
		source => 'puppet:///modules/redelinux/etc/profile.d/nfs_path.sh',
		require => Package['autofs']
	}
}
