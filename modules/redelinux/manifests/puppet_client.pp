class redelinux::puppet_client
{
	file { 'puppet.conf':
		path => '/etc/puppet/puppet.conf',
		source => 'puppet:///modules/redelinux/etc/puppet/puppet.conf'
	}
	
	service { 'puppet':
		ensure => running,
		subscribe => File['puppet.conf']
	}
}
