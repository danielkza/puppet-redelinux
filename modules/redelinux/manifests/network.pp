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
    }
    
    # Fix debians stupid habit of not sending hostname on DHCP requests

    if $redelinux::debian_pre_wheezy
    {
        file { 'dhclient_hostname_fix':
            ensure => file,
            path   => '/etc/dhcp/dhclient-enter-hooks.d/hostname',
            source => 'puppet:///modules/redelinux/etc/dhcp/dhclient-enter-hooks.d/hostname',
            notify => Service['networking']
        }
        
        service { 'networking': }
    }
}
