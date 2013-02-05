class redelinux::network
{
	# Fix debian's weird hosts file
	host { "$hostname":
		ensure => absent,
	}
	
	host { 'localhost':
		ensure       => present,
		ip           => '127.0.0.1',
		host_aliases => undef,
		require      => Host["$hostname"],
	}
	
	# Fix debians stupid habit of not sending hostname on DHCP requests
	file { "dhclient_hostname_fix":
		ensure => directory,
		path   => "/etc/dhcp/dhclient-enter-hooks.d/",
		source => "puppet:///modules/redelinux/etc/dhcp/dhclient-enter-hooks.d/",
		recurse => remote,
	}
	
	service { "networking":
		subscribe => File['dhclient_hostname_fix']
	}	
}
